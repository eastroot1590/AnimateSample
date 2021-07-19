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
        guard let controller = transitionContext.viewController(forKey: .to) as? CitizenDetailViewController else {
            return
        }
        
        // TODO: 애니메이션 단계에서 이미지 topAnchor를 재설정하도록 하면 네비게이션 컨트롤러때문에 살짝 튀는 문제를 해결하면서 더 다양한 형태로 디테일 화면을 구성할 수 있다.
        transitionContext.containerView.addSubview(controller.view)
        
        // 시작 프레임
        let initialFrame = selectedCell.convert(selectedCell.primeView.frame, to: transitionContext.containerView)
        controller.view.frame = initialFrame
        controller.view.layoutIfNeeded()
        
        // 최종 프레임
        let finalFrame = transitionContext.finalFrame(for: controller)
        
        // 애니메이션
        let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.75) {
            controller.view.frame = finalFrame

            controller.view.layoutIfNeeded()
        }
        
        animation.addCompletion({ position in
            transitionContext.completeTransition(position == .end)
        })
        
        animation.startAnimation()
    }
}
