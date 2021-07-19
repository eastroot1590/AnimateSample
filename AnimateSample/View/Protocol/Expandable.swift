//
//  Expandable.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// ExpandAnimator를 사용할 수 있는 UIView
protocol Expandable: UIView {
    /// 메인 view
    var primeView: UIView { get }
}
