//
//  ExpandPushAnimator.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class ExpandPushAnimator: ExpandAnimator, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let controller = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(controller.view)
        
        // 시작 프레임
        let initialFrame = selectedCell.convert(selectedCell.primeView.frame, to: transitionContext.containerView)
        controller.view.frame = initialFrame
        controller.view.layoutIfNeeded()
        
        selectedCell.primeView.isHidden = true
        
        // 최종 프레임
        let finalFrame = transitionContext.finalFrame(for: controller)
        
        // 애니메이션
        let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.75) {
            controller.view.frame = finalFrame

            controller.view.layoutIfNeeded()
        }
        
        animation.addCompletion({ _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        animation.startAnimation()
    }
}
