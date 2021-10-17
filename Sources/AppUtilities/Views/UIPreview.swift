//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

#if canImport(SwiftUI) && DEBUG

import SwiftUI

/// Provides SwiftUI representation of UIViewController to be shown in Xcode Canvas Preview.
///
/// ## Usage:
/// ```swift
/// class ViewController: UIViewController {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         ...
///     }
/// }
///
/// #if DEBUG
/// import SwiftUI
///
/// struct ViewController_Preview: PreviewProvider {
///     static var previews: some View {
///         UIViewControllerPreview {
///             ViewController()
///         }
///     }
/// }
/// #endif
/// ```
@available(iOS 13.0, *)
public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController
    
    public init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif

#if canImport(SwiftUI) && DEBUGç
import SwiftUI

/// Provides SwiftUI representation of UIView to be shown in Xcode Canvas Preview.
///
/// ## Usage:
/// ```swift
/// class AppTableViewCell: UITableViewCell {
///     ...
/// }
///
/// #if DEBUG
/// import SwiftUI
///
/// struct AppTableViewCell_Preview: PreviewProvider {
///     static var previews: some View {
///         UIViewPreview {
///             AppTableViewCell(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
///         }
///     }
/// }
/// #endif
/// ```
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

