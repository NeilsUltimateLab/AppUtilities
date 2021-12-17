import UIKit

/**
## Usage: -

 ```swift
 
 extension TargetViewController: UIViewControllerTransitioningDelegate {
 
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         let animator = SheetDismissAnimator()
         animator.startOrigin = self.startOrigin
         animator.endOrigin = self.endOrigin
         return animator
     }
     
     func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         let animator = SheetAnimator()
         animator.startOrigin = self.startOrigin
         animator.endOrigin = self.endOrigin
         return animator
     }
     
     func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
         let presentedController = SheetPresentationController(presentedViewController: presented, presenting: presenting)
         presentedController.endOrigin = self.endOrigin
         presentedController.canDismissFromOutside = true
         return presentedController
     }
 }
```
*/
public class SheetAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var startOrigin: CGPoint?
    public var endOrigin: CGPoint?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toVC = transitionContext.viewController(forKey: .to),
            let startOrigin = self.startOrigin,
            let endOrigin = self.endOrigin
        else { return }
        
        transitionContext.containerView.addSubview(toView)
        let finalRect = transitionContext.finalFrame(for: toVC)
        toView.frame = CGRect(origin: startOrigin, size: finalRect.size)
        toView.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            toView.frame = CGRect(origin: endOrigin, size: finalRect.size)
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
