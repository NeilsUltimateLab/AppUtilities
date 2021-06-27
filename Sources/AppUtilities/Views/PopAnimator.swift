//
//  File.swift
//  
//
//  Created by Neil Jain on 6/27/21.
//

import UIKit

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
            let toVC = self.isPresenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from),
            let originalSourceView = sourceView,
            let sourceView = sourceView.snapshotView(afterScreenUpdates: true),
            let sourceRect = sourceRect
        else { return }
        
        let containerView = transitionContext.containerView
        self.destinationRect = transitionContext.finalFrame(for: toVC)
                
        let isPresenting = self.isPresenting

        containerView.addSubview(sourceView)
        
        originalSourceView.alpha = 0
        sourceView.frame = sourceRect
        containerView.addSubview(toVC.view)
        
        let sourceViewCenter = sourceView.center
        
        toVC.view.frame = destinationRect
        toVC.view.center = isPresenting ? CGPoint(x: sourceRect.midX, y: sourceRect.midY) : containerView.center
        toVC.view.layer.cornerRadius = 12
        toVC.view.layer.masksToBounds = true
        toVC.view.transform = isPresenting ? self.transform(fromRect: sourceRect, toRect: destinationRect) : .identity
        toVC.view.alpha = isPresenting ? 0 : 1
        
        if !isPresenting {
            sourceView.alpha = 0
            sourceView.center = containerView.center
            sourceView.transform = self.squareTransform(fromRect: toVC.view.frame, toRect: sourceRect)
            containerView.bringSubviewToFront(sourceView)
        }
        impactFeedbackGenerator.impactOccurred()
                
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            toVC.view.alpha = isPresenting ? 1 : 0
            sourceView.alpha = isPresenting ? 0 : 1
            
            toVC.view.transform = isPresenting ? .identity : self.transform(fromRect: sourceRect, toRect: self.destinationRect)
            
            toVC.view.center = isPresenting ? containerView.center : sourceViewCenter
            sourceView.center = isPresenting ? containerView.center : sourceViewCenter
            sourceView.transform = isPresenting ? self.squareTransform(fromRect: self.destinationRect, toRect: sourceRect) : .identity
            
        } completion: { (success) in
            if !self.isPresenting {
                originalSourceView.alpha = 1
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
    
    private func squareTransform(fromRect: CGRect, toRect: CGRect) -> CGAffineTransform {
        let scaleX = fromRect.width / toRect.width
        return CGAffineTransform(scaleX: scaleX, y: scaleX)
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
        return controller
    }
}

extension CGRect {
    var squared: CGRect {
        let width = min(self.width, self.height)
        return CGRect(origin: self.origin, size: CGSize(width: width, height: width))
    }
}

