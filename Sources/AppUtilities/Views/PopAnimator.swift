//
//  File.swift
//  
//
//  Created by Neil Jain on 6/27/21.
//

import UIKit

/// This provides concrete class the zoom in animation for `UIViewController`.
public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var isPresenting: Bool = true
    
    public var duration: TimeInterval = 0.5
    
    public var sourceView: UIView!
    public var sourceRect: CGRect!
    public var destinationRect: CGRect!
    public var leftPadding: CGFloat = 20
    public var width: CGFloat?
    public var topPadding: CGFloat = 100
    public var height: CGFloat?
    public var shouldBlur: Bool = true
    public var canDismissFromOutside: Bool = false
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator()
    
    public override init() {
        super.init()
        impactFeedbackGenerator.prepare()
    }
        
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        sourceView.alpha = 1
        guard
            let toVC = self.isPresenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from),
            let toView = self.isPresenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from),
            let originalSourceView = sourceView,
            let sourceView = sourceView.snapshotView(afterScreenUpdates: true),
            let sourceRect = sourceRect
        else { return }
        
        let containerView = transitionContext.containerView
        self.destinationRect = transitionContext.finalFrame(for: toView)
        var toSnapView: UIView?
                
        let isPresenting = self.isPresenting

        if isPresenting {
            containerView.addSubview(toVC)
            toVC.frame = destinationRect
            toVC.transform = CGAffineTransform(from: destinationRect, to: sourceRect)
            toVC.layer.cornerRadius = 12
            toVC.layer.masksToBounds = true
        } else {
            if let snapView = toVC.snapshotView(afterScreenUpdates: true) {
                toSnapView = snapView
                toVC.removeFromSuperview()
                containerView.addSubview(snapView)
                snapView.frame = destinationRect
            }
        }
        
        containerView.addSubview(sourceView)
        
        originalSourceView.alpha = 0
        sourceView.frame = sourceRect
            
        toVC.alpha = isPresenting ? 0 : 1
        
        if !isPresenting {
            containerView.bringSubviewToFront(sourceView)
            sourceView.alpha = 0
            sourceView.frame = destinationRect
            toVC.frame = destinationRect
            toVC.transform = .identity
        }
        impactFeedbackGenerator.impactOccurred()
                
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            
            if isPresenting {
                toVC.transform = .identity
            } else {
                toSnapView?.transform = CGAffineTransform(from: self.destinationRect, to: sourceRect)
                toSnapView?.alpha = 0
            }
            sourceView.frame = !isPresenting ? self.sourceRect : self.destinationRect
            toVC.alpha = isPresenting ? 1 : 0
            sourceView.alpha = isPresenting ? 0 : 1
            
        } completion: { (success) in
            if !self.isPresenting {
                originalSourceView.alpha = 1
                self.sourceView.alpha = 1
                self.impactFeedbackGenerator.impactOccurred()
            }
            transitionContext.completeTransition(success)
        }
    }
    
    private func transform(fromRect: CGRect, toRect: CGRect) -> CGAffineTransform {
        let scaleX = fromRect.width / toRect.width
        let scaleY = fromRect.height / toRect.height
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    deinit {
        print("Deinit called from ZoomPreviewAnimator")
    }
    
}

extension PopAnimator: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopPresentationController(presentedViewController: presented, presenting: presenting)
        controller.targetHeight = self.height
        controller.shouldBlur = self.shouldBlur
        controller.canDismissFromOutside = self.canDismissFromOutside
        return controller
    }
}
