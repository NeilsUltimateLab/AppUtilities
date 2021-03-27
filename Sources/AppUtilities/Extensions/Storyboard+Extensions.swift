//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public protocol StoryboardIDProvider: RawRepresentable where Self.RawValue == String {
    
}

public protocol StoryboardInstantiable {
    static var storyboardIdentifier: String { get }
    static func instantiate<S: StoryboardIDProvider>(from storyboard: S) -> Self
    static func instantiateInitialViewController<S: StoryboardIDProvider>(from storyboard: S) -> Self
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        String(describing: self)
    }
    
    static func instantiate<S: StoryboardIDProvider>(from storyboard: S) -> Self {
        UIStoryboard.storyboard(storyboard: storyboard).instantiateViewController()
    }
    
    static func instantiateInitialViewController<S>(from storyboard: S) -> Self where S : StoryboardIDProvider {
        UIStoryboard.storyboard(storyboard: storyboard).instantiateInitialViewController()
    }
}

extension UIViewController: StoryboardInstantiable {}

public extension UIStoryboard {
    convenience init<S: StoryboardIDProvider>(storyboard: S, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    static func storyboard<S: StoryboardIDProvider>(storyboard: S, bundle: Bundle? = nil) -> UIStoryboard {
        UIStoryboard(storyboard: storyboard, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Could not find view controller with name: \(T.storyboardIdentifier)")
        }
        return viewController
    }
    
    func instantiateInitialViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Could not find view controller with name: \(T.storyboardIdentifier)")
        }
        return viewController
    }
}
