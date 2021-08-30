//
//  ChartERElements.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/26.
//

import Foundation

/// ChartERView가 표현할 수 있는 값의 집합
struct ChartERElements {
    static let empty = ChartERElements(name: nil, values: [])
    
    var name: String? = nil
    var values: [Float] = []
}
