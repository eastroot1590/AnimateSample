//
//  ExpandAnimator.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class ExpandAnimator: UIPercentDrivenInteractiveTransition {
    let selectedCell: Expandable
    let originFrame: CGRect
    
    init(selectedCell: Expandable, originFrame: CGRect) {
        self.selectedCell = selectedCell
        self.originFrame = originFrame
    }
}
