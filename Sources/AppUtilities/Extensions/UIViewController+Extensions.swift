//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public extension UIViewController {
    func showAlert(title: String? = nil, message: String, okAction: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            okAction?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String, actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(for error: AppErrorProvider, completion: (()->Void)? = nil) {
        self.showAlert(message: error.message) {
            completion?()
        }
    }
}
