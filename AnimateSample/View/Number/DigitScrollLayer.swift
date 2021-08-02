//
//  DigitScrollLayer.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/28.
//

import UIKit

class DigitScrollLayer: CAScrollLayer {
    var number: Int = 0
    
    private var size: CGSize = .zero
    
    init(font: UIFont, digitSize: CGSize) {
        super.init()
        
        self.size = digitSize
        
        for index in 0...10 {
            let digitLayer = CATextLayer()
            digitLayer.frame = CGRect(origin: CGPoint(x: 0, y: CGFloat(index) * size.height), size: size)
            digitLayer.string = index == 0 ? " " : String(index-1)
            digitLayer.alignmentMode = .center
            digitLayer.contentsScale = UIScreen.main.scale
            digitLayer.fontSize = font.pointSize
            digitLayer.font = font
            digitLayer.foregroundColor = UIColor.black.cgColor
            addSublayer(digitLayer)
        }
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 폰트를 변경한다.
    /// 이미 스크롤 애니메이션이 재생중이라면 다시 재생한다.
    func setFont(_ font: UIFont, digitSize: CGSize) {
        self.size = digitSize

        var index: CGFloat = 0
        
        sublayers?.forEach({ sublayer in
            guard let subTextLayer = sublayer as? CATextLayer else {
                return
            }
            
            subTextLayer.frame = CGRect(origin: CGPoint(x: 0, y: index * size.height), size: size)
            subTextLayer.font = font
            subTextLayer.fontSize = font.pointSize
            
            index += 1
        })
        
        if let playingAnimation = animation(forKey: "scroll") {
            scrollToNumber(duration: playingAnimation.duration, offset: 0)
        } else {
            scrollToNumber(duration: 0, offset: 0)
        }
    }
    
    func setNumber(_ newNumber: Int, duration: TimeInterval, offset: TimeInterval) {
        self.number = newNumber
        
        scrollToNumber(duration: duration, offset: offset)
    }
    
    /// 스크롤 애니메이션을 재생한다.
    /// 이미 애니메이션 중이라면 해당 위치부터 다시 새로운 애니메이션을 재생한다.
    /// - Parameter duration : 애니메이션 최소 재생시간
    /// - Parameter offset : 애니메이션 재생시간 차이
    private func scrollToNumber(duration: TimeInterval, offset: TimeInterval) {
        let currentTransform: CATransform3D = presentation()?.value(forKeyPath: "sublayerTransform") as? CATransform3D ?? CATransform3DIdentity
        let targetTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -CGFloat(number + 1) * size.height, 0)
        
        let animation = CABasicAnimation(keyPath: "sublayerTransform")
        animation.duration = duration + offset
        animation.fromValue = currentTransform
        animation.toValue = targetTransform
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.delegate = self
        add(animation, forKey: "scroll")
        
        sublayerTransform = targetTransform
    }
}

extension DigitScrollLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            removeAnimation(forKey: "scroll")
        }
    }
}
