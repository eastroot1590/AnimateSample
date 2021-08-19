//
//  DragCellInfo.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

struct DragCellInfo {
    enum CellSize {
        case small
        case medium
        case large
        case huge
    }
    
    let color: UIColor
    let size: CellSize
}
