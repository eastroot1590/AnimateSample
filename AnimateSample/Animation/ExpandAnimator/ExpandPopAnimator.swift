//
//  ExpandPopAnimator.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class ExpandPopAnimator: ExpandAnimator, UIViewControllerAnimatedTransitioning {
    private var animatorForCurrentSession: UIViewImplicitlyAnimating?
    
    override func cancel() {
        super.cancel()
        
        animatorForCurrentSession = nil
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animatorForCurrentSession = animatorForCurrentSession {
            return animatorForCurrentSession
        }
        
        var animator = UIViewPropertyAnimator()
        
        if let controller = transitionContext.viewController(forKey: .from) {
            animator = generateAnimator(transitionContext, with: controller)
            self.animatorForCurrentSession = animator
        }
        
        return animator
    }
    
    private func generateAnimator(_ transitionContext: UIViewControllerContextTransitioning, with controller: UIViewController) -> UIViewPropertyAnimator {
        // 이전 화면
        if let toVC = transitionContext.viewController(forKey: .to) {
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            transitionContext.containerView.addSubview(toVC.view)
        }
        
        // dimming view
        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        dimmingView.frame = transitionContext.containerView.frame
        transitionContext.containerView.addSubview(dimmingView)
        
        // 현재 화면
        transitionContext.containerView.addSubview(controller.view)
        
        // 현재 화면의 시작 프레임
        let initialFrame = transitionContext.initialFrame(for: controller)
        controller.view.frame = initialFrame
        
        // 애니메이션
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.75)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: animator.duration, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    controller.view.frame = initialFrame.insetBy(dx: initialFrame.width * 0.05, dy: initialFrame.height * 0.1)

                    controller.view.layer.cornerRadius = self.originFrame.width / 2
                    controller.view.layer.masksToBounds = true
                })

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    dimmingView.alpha = 0

                    controller.view.frame = self.originFrame
                })
            })
        }
        
        animator.addCompletion({ position in
            if position == .end {
                self.selectedCell.primeView.isHidden = false
                controller.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        animator.isUserInteractionEnabled = true
        
        return animator
    }
}
