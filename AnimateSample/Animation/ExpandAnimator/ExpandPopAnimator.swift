//
//  ExpandPopAnimator.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class ExpandPopAnimator: ExpandAnimator, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let controller = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        if let toVC = transitionContext.viewController(forKey: .to) {
            transitionContext.containerView.addSubview(toVC.view)
        }
        
        transitionContext.containerView.addSubview(controller.view)
        
        // 시작 프레임
        let initialFrame = transitionContext.initialFrame(for: controller)
        controller.view.frame = initialFrame
        controller.view.layoutIfNeeded()
        
        // 최종 프레임
        let finalFrame = selectedCell.convert(selectedCell.primeView.frame, to: transitionContext.containerView)
        
        // 애니메이션
        let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.75) {
            controller.view.frame = finalFrame

            controller.view.layoutIfNeeded()
        }
        
        animation.addCompletion({ position in
            if position == .end {
                controller.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        animation.startAnimation()
    }
}
