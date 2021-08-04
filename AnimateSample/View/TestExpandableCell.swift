//
//  TestExpandableCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/02.
//

import UIKit

class TestExpandableCell: UICollectionViewCell, Expandable {
    var primeView: UIView {
        contentView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBlue
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
