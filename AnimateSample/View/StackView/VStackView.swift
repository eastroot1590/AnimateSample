//
//  VStackView.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

class VStackView: UIView, Stackable {
    var lastStack: UIView?
    
    // TODO: 두 값을 하나로 묶어야됨 -> Stackable로 묶자
    var stacks: [UIView] = []
    var spacings: [CGFloat] = []
    
    // layout
    /// 배너가 있을 경우 배너 크기만큼 띄우고 나머지 view를 위치시킨다.
    var minHeight: CGFloat = 0
    
    func push(_ stack: UIView, spacing: CGFloat) {
        addSubview(stack)
        
        stacks.append(stack)
        spacings.append(spacing)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var totalHeight: CGFloat = minHeight
        
        for stack in stacks {
            stack.frame.origin = CGPoint(x: 20, y: totalHeight)
            stack.frame.size = CGSize(width: frame.width, height: stack.frame.height)
            
            totalHeight += stack.frame.height
        }
    }
}
