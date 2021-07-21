//
//  Stackable.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

/// view를 추가할 수록 점점 크기가 커지는 view
// TODO: stack에 추가할 수 있는 view로 만들자. spacing 값을 가지고 있도록
protocol Stackable: UIView {
    /// 가장 마지막에 추가한 view
    var lastStack: UIView? { get }
    
    var stacks: [UIView] { get }
    var spacings: [CGFloat] { get }
    
    func push(_ stack: UIView, spacing: CGFloat)
}
