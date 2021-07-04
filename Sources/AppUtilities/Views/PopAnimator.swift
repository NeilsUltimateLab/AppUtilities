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
    public var shouldBlur: Bool = true
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator()
    
    private lazy var shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.darkGray.withAlphaComponent(1).cgColor
        view.layer.shadowOpacity = 0
        view.layer.shadowRadius = 24
        view.layer.shadowOffset = .zero
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 12
        view.alpha = 0
        return view
    }()
    
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
                
        let isPresenting = self.isPresenting

        containerView.addSubview(toVC)
        containerView.addSubview(sourceView)
        containerView.addSubview(shadowView)
        
        originalSourceView.alpha = 0
        sourceView.frame = sourceRect
                
        //toVC.frame = sourceRect
        toVC.layer.cornerRadius = 12
        toVC.layer.masksToBounds = true
        toVC.alpha = isPresenting ? 0 : 1
        shadowView.frame = toVC.frame
        
        if !isPresenting {
            containerView.bringSubviewToFront(sourceView)
            sourceView.alpha = 0
            sourceView.frame = destinationRect
            //toVC.frame = sourceView.frame
        }
        impactFeedbackGenerator.impactOccurred()
                
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            self.shadowView.layer.shadowOpacity = isPresenting ? 1 : 0
            
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
        return controller
    }
}

extension CGRect {
    var squared: CGRect {
        let width = min(self.width, self.height)
        return CGRect(origin: self.origin, size: CGSize(width: width, height: width))
    }
}

