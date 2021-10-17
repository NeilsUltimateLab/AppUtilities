//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

/// Provides the default implementation for child view controller integration.
///
/// - Usage:
/// ```swift
/// class ViewController: UIViewController, ContainmentProvider {
///
///     private lazy var listViewController: UIViewController = { ... }()
///
///     private lazy var listContainerView: UIView = {
///         let view = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 300)
///         return view
///     }()
///
///     private func configureFullScreenChild() {
///         self.addChild(listViewController, to: self.view)
///     }
///
///     private func configureInScreenChild() {
///         self.addChild(listViewController, to: self.listContainerView)
///     }
///
///     private func removeChild() {
///         self.removeChild(listViewController)
///     }
/// }
/// ```
public protocol ContainmentProvider: AnyObject {
    
    /// Adds child view controller's content inside `containerView`.
    func addChild(_ viewController: UIViewController, to containerView: UIView)
    
    /// Removes the child view controller from parents with its content.
    func removeChild(_ viewController: UIViewController?)
}

public extension ContainmentProvider where Self: UIViewController {
    
    func addChild(_ viewController: UIViewController, to containerView: UIView) {
        self.addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        viewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        viewController.didMove(toParent: self)
    }
    
    /// Adds child view controller's content inside `containerView` respecting the safe area of `containerView`.
    func addChild(_ viewController: UIViewController, toSafeAreaOf containerView: UIView) {
        self.addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        viewController.view.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.rightAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor).isActive = true
        viewController.didMove(toParent: self)
    }
    
    func removeChild(_ viewController: UIViewController?) {
        viewController?.willMove(toParent: nil)
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()
        viewController?.didMove(toParent: nil)
    }
}
