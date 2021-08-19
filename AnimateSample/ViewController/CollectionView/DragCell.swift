//
//  DragCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class DragCell: UICollectionViewCell {
    var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fatch(_ index: Int) {
        self.index = index
    }
}
