//
//  LongDragCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class LongDragCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemRed
        
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
