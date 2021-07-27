//
//  UInt+AnimateSample.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import Foundation

extension UInt {
    func pow(_ rhs: UInt) -> UInt {
        var result: UInt = 1
        for _ in 0..<rhs {
            result *= self
        }
        
        return result
    }
}
