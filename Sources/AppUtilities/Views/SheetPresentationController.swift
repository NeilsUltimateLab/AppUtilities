//
//  File.swift
//  My App
//
//  Created by Yashesh on 17/12/21.
//

import UIKit

public class SheetPresentationController: UIPresentationController {
    
    public var endOrigin: CGPoint?
    public var canDismissFromOutside: Bool = true
    
    public lazy var chromeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.alpha = 0
        return view
    }()
    
    private lazy var gesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        return gesture
    }()
    
    private func setupChromeView() {
        guard let containerView = self.containerView else { return }
        containerView.addSubview(chromeView)
        chromeView.addGestureRecognizer(gesture)
        
        chromeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        chromeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        chromeView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        chromeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    public override func presentationTransitionWillBegin() {
        setupChromeView()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 1
            return
        }
        coordinator.animate { context in
            self.chromeView.alpha = 1
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 0
            return
        }
        
        coordinator.animate { context in
            self.chromeView.alpha = 0
        } completion: { _ in
            self.chromeView.removeFromSuperview()
        }
    }
    
    @objc private func tapAction() {
        if canDismissFromOutside {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        self.presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard self.containerView != nil,
              self.presentedView != nil,
              let endOrigin = self.endOrigin
        else { return .zero }
        
        let size = presentedViewController.preferredContentSize
        
        return CGRect(origin: endOrigin, size: size)
    }
}
