//
//  AnimateSampleColor.swift
//  Copybucks
//
//  Created by 이동근 on 2021/09/09.
//

import UIKit

struct AnimateSampleColor: Codable {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 1
    
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(_ uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
