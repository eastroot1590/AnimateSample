//
//  ChartElements.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/26.
//

import Foundation

/// ChartERView가 표현할 수 있는 값의 집합
struct ChartElements {
    static let empty = ChartElements(name: nil, values: [])
    
    var name: String? = nil
    var values: [Float] = []
}
