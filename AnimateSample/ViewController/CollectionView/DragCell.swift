//
//  DragCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class DragCell: UICollectionViewCell {
    var index: Int = 0
    
    var shaking: Bool = false
    
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
        
        print("prepare and stop")
        stop()
    }
    
    func fatch(_ index: Int) {
        self.index = index
    }
    
    func shake(_ odd: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.calculationMode = .linear
        animation.values = [
            CGFloat(0).radian,
            CGFloat(-5).radian * odd,
            CGFloat(5).radian * odd,
            CGFloat(0).radian
        ]
        animation.keyTimes = [
            0,
            0.25,
            0.75,
            1
        ]
        animation.repeatCount = .infinity
        animation.duration = 0.5
        layer.add(animation, forKey: "transform")
    }
    
    func stop() {
        layer.removeAnimation(forKey: "transform")
    }
}
