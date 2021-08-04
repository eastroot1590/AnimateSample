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
        
        // 현재 화면
        transitionContext.containerView.addSubview(controller.view)
        
        // 현재 화면의 시작 프레임
        let initialFrame = transitionContext.initialFrame(for: controller)
        controller.view.frame = initialFrame
        
        // 현재 화면의 최종 프레임
        let finalBackgroundColor = selectedCell.primeView.backgroundColor
        
        // 애니메이션
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.75) {
            controller.view.frame = self.originFrame
            controller.view.layer.cornerRadius = self.selectedCell.primeView.layer.cornerRadius
            controller.view.backgroundColor = finalBackgroundColor

            controller.view.layoutIfNeeded()
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
