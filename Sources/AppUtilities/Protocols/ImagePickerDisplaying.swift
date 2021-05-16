//
//  File.swift
//  
//
//  Created by Neil on 16/05/21.
//

import UIKit

#if canImport(AVFoundation) && canImport(Photos)
import AVFoundation
import Photos
#endif


public protocol ImagePickerPermissionRequesting {
    func cameraAccessPermissionCheck(completion: @escaping (Bool) -> Void)
    func photosAccessPermissionCheck(completion: @escaping (Bool)->Void)
}

public protocol ImagePickerDisplaying: ImagePickerPermissionRequesting {
    func pickerAction(sourceType : UIImagePickerController.SourceType)
    func alertForPermissionChange(forFeature feature: String, library: String, action: String)
}

public extension ImagePickerPermissionRequesting {
    func cameraAccessPermissionCheck(completion: @escaping (Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAutherisationState = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAutherisationState {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: cameraMediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            break
        }
    }
    
    func photosAccessPermissionCheck(completion: @escaping (Bool)->Void) {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        switch photosStatus {
        case .authorized:
            completion(true)
        case .denied, .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            })
        case .limited:
            completion(true)
        @unknown default:
            break
        }
    }
    
}

public extension ImagePickerPermissionRequesting where Self: UIViewController {
    func alertForPermissionChange(forFeature feature: String, library: String, action: String) {
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            UIApplication.shared.openSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Please enable camera access from Settings > reiwa.com > Camera to take photos
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "App"
        let alert = UIAlertController(
            title: "\"\(appName)\" Would Like to Access the \(library)",
            message: "Please enable \(library) access from Settings > \(appName) > \(feature) to \(action) photos",
            preferredStyle: .alert)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestForCameraAccess(completion: @escaping (Bool)->Void) {
        self.cameraAccessPermissionCheck { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                self.alertForPermissionChange(forFeature: "Camera", library: "Camera", action: "take")
            }
        }
    }
    
    func requestForPhotosAccess(completion: @escaping (Bool)->Void) {
        self.photosAccessPermissionCheck(completion: { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                self.alertForPermissionChange(forFeature: "Photos", library: "Photo Library", action: "select")
            }
        })
    }
}

public extension ImagePickerDisplaying where Self: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func showMediaPickerOptions() {
        let fromCameraAction = UIAlertAction(title: "Capture photo from camera", style: .default) { (_) in
            self.pickerAction(sourceType: .camera)
        }
        
        let fromPhotoLibraryAction = UIAlertAction(title: "Select from photo library", style: .default) { (_) in
            self.pickerAction(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(fromCameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(fromPhotoLibraryAction)
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerAction(sourceType : UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            if sourceType == .camera {
                self.cameraAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    }else {
                        self.alertForPermissionChange(forFeature: "Camera", library: "Camera", action: "take")
                    }
                })
            }
            if sourceType == .photoLibrary {
                self.photosAccessPermissionCheck(completion: { (success) in
                    if success {
                        self.present(picker, animated: true, completion: nil)
                    }else {
                        self.alertForPermissionChange(forFeature: "Photos", library: "Photo Library", action: "select")
                    }
                })
            }
            
        }
    }
    
}

public extension UIApplication {
    func openSettings() {
        let urlString = UIApplication.openSettingsURLString
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

public extension UIImageView {
    func fetchImageAsset(_ asset: PHAsset?, targetSize: CGSize, contentMode: PHImageContentMode = .aspectFit, options: PHImageRequestOptions? = nil, completion: ((Bool)->Void)?) {
        
        guard let asset = asset else {
            completion?(false)
            return
        }
        
        let resultHandler: (UIImage?, [AnyHashable: Any]?)->Void = { image, info in
            self.image = image
            completion?(true)
        }
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: options,
            resultHandler: resultHandler
        )
    }
}