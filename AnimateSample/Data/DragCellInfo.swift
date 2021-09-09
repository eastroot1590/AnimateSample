//
//  DragCellInfo.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

struct DragCellInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case color
        case size
    }
    
    enum CellSize: String, Codable {
        case small
        case medium
        case large
    }
    
    let color: UIColor
    let size: CellSize
    
    init(color: UIColor, size: CellSize) {
        self.color = color
        self.size = size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.color = try container.decode(AnimateSampleColor.self, forKey: .color).uiColor
        self.size = try container.decode(CellSize.self, forKey: .size)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(AnimateSampleColor(color), forKey: .color)
        try container.encode(size, forKey: .size)
    }
}
