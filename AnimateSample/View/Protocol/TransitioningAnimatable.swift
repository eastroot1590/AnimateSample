//
//  TransitioningAnimatable.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 화면 전환 효과를 커스텀 한 UIViewController
protocol TransitioningAnimatable: UIViewController {
    func pushAnimator() -> UIViewControllerAnimatedTransitioning?
    func popAnimator() -> UIViewControllerAnimatedTransitioning?
}
