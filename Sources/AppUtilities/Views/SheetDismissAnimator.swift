import UIKit

public class SheetDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var startOrigin: CGPoint?
    public var endOrigin: CGPoint?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let viewController = transitionContext.viewController(forKey: .from),
            let startOrigin = self.startOrigin,
            let endOrigin = self.endOrigin
        else { return }
        
        if fromView.superview == nil {
            transitionContext.containerView.addSubview(fromView)
        }
        let finalFrame = transitionContext.finalFrame(for: viewController)
        fromView.frame = CGRect(origin: endOrigin, size: finalFrame.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            fromView.frame = CGRect(origin: startOrigin, size: finalFrame.size)
        } completion: { completed in
            transitionContext.completeTransition(completed)
            fromView.removeFromSuperview()
        }
    }
}

