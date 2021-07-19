//
//  ExpandAnimator.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class ExpandAnimator: NSObject {
    let selectedCell: Expandable
    
    init(selectedCell: Expandable) {
        self.selectedCell = selectedCell
    }
}
