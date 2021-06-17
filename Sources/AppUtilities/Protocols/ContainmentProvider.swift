//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public protocol ContainmentProvider: class {
    func addChild(_ viewController: UIViewController, to containerView: UIView)
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
