//
//  TransitioningInteractable.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/26.
//

import UIKit

protocol TransitioningInteractable: TransitioningAnimatable {
    var interactiveTransitioning: Bool { get }
    
    var threshold: CGFloat { get }
    
    func interactivePopAnimator() -> UIPercentDrivenInteractiveTransition?
    
    func interactiveDidBegin()
    func interactiveDidChange(_ percent: CGFloat)
    func interactiveDidEnd(_ percent: CGFloat)
    func interactiveDidCanceled(_ percent: CGFloat)
}
