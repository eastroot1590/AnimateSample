//
//  GridUXCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class GridUXCell: UICollectionViewCell {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        stop()
    }
    
    func fatch(_ index: Int) {
        self.index = index
    }
    
    func shake(_ odd: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.calculationMode = .linear
        animation.values = [
            CATransform3DIdentity,
            CATransform3DRotate(CATransform3DIdentity, CGFloat(-1.5).radian * odd, 0, 0, 1),
            CATransform3DRotate(CATransform3DIdentity, CGFloat(1.5).radian * odd, 0, 0, 1),
            CATransform3DIdentity
        ]
        animation.keyTimes = [
            0,
            0.25,
            0.75,
            1
        ]
        animation.repeatCount = .infinity
        animation.duration = 0.25
        layer.add(animation, forKey: "transform")
    }
    
    func stop() {
        layer.removeAnimation(forKey: "transform")
    }
}
