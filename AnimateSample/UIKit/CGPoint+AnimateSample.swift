//
//  CGPoint+AnimateSample.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/24.
//

import UIKit

extension CGPoint {
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    func clamped(to: CGRect) -> CGPoint {
        return CGPoint(x: min(max(self.x, to.minX), to.maxX), y: min(max(self.y, to.minY), to.maxY))
    }
}
