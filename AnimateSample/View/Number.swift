//
//  Number.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class Number: UIView {
    let digitCount: UInt
    /// 가장 우측부터 각 자리 숫자를 표시한다.
    /// - [0] : 가장 낮은 자리
    /// - [max] : 가장 높은 자리 (0 포함. 0을 포함하지 않는 가장 높은 자리는 getMostLeftDigit() 함수를 통해 계산)
    var digitScrollLayers: [CAScrollLayer] = []
        
    var digitWidth: CGFloat {
        font.pointSize * 0.75
    }
    var digitHeight: CGFloat {
        font.lineHeight
    }
    
    var animationDuration: TimeInterval = 1
    var animationInerval: TimeInterval = 0.2
    
    private var font: UIFont = .systemFont(ofSize: 16)
    
    private var number: UInt = 0
    
    /// 숫자 한자리를 표시한다.
    private var digitScroll: CAScrollLayer {
        let scrollLayer = CAScrollLayer()
        print("make digitScroll")
        
        for i in 0...10 {
            let digitLayer = CATextLayer()
            digitLayer.frame = CGRect(origin: CGPoint(x: 0, y: CGFloat(i) * digitHeight), size: CGSize(width: digitWidth, height: digitHeight))
            digitLayer.string = i == 0 ? " " : String(i-1)
            digitLayer.alignmentMode = .center
            digitLayer.contentsScale = UIScreen.main.scale
            digitLayer.fontSize = font.pointSize
            digitLayer.font = font
            digitLayer.foregroundColor = UIColor.black.cgColor
            scrollLayer.addSublayer(digitLayer)
        }
        
        return scrollLayer
    }
    
    init(_ digitCount: UInt) {
        self.digitCount = digitCount
        
        super.init(frame: .zero)
        
        for _ in 0..<digitCount {
            let digitScroll = digitScroll
            layer.addSublayer(digitScroll)
            
            digitScrollLayers.append(digitScroll)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let digitWidth = self.digitWidth
        let digitHeight = self.digitHeight
        
        for digit in 0..<digitCount {
            digitScrollLayers[Int(digit)].frame = CGRect(origin: CGPoint(x: CGFloat(digitCount - digit) * digitWidth - digitWidth, y: 0), size: CGSize(width: digitWidth, height: digitHeight))
        }
        
        frame.size = CGSize(width: CGFloat(digitCount) * digitWidth, height: digitHeight)
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
        
        // Q: for 루프 안에서 self를 참조하는것 보다 이렇게 한 번 copy 해놓고 쓰는게 좀 더 빠르지 않을까?
        let digitWidth = self.digitWidth
        let digitHeight = self.digitHeight
        
        digitScrollLayers.forEach { digitScroll in
            var index: CGFloat = 0
            
            digitScroll.sublayers?.forEach({ sublayer in
                guard let subTextLayer = sublayer as? CATextLayer else {
                    return
                }
                
                subTextLayer.frame = CGRect(origin: CGPoint(x: 0, y: index * digitHeight), size: CGSize(width: digitWidth, height: digitHeight))
                subTextLayer.font = font
                subTextLayer.fontSize = font.pointSize
                
                index += 1
            })
        }
        
        setNeedsLayout()
    }
    
    func setNumber(_ number: UInt) {
        self.number = min(number, UInt(10).pow(digitCount) - 1)
        
        let mostLeftDigit = getMostLeftDigit()
        
        for digit in 0..<digitCount {
            let devider = UInt(10).pow(digit)
            let digitNumber = (self.number / devider) % 10
            
            scrollTo(digitScrollLayers[Int(digit)], digitNumber: digitNumber, digit: digit, visible: digit <= mostLeftDigit)
        }
    }
    
    /// 의미없는 0 자리를 제외한 가장 좌측 자리
    /// - returns : 의미를 가지는 가장 좌측 자리
    private func getMostLeftDigit() -> UInt {
        for digit in (0..<digitCount).reversed() {
            let devider = UInt(10).pow(digit)

            let value = number / devider

            if value > 0 {
                return digit
            }
        }

        return 0
    }
    
    /// 스크롤 애니메이션을 재생한다.
    /// 이미 애니메이션 중이라면 해당 위치부터 다시 새로운 애니메이션을 재생한다.
    /// - Parameter digitScroll : 애니메이션을 재생할 CAScrollLayer
    /// - Parameter digitNumber : 해당 자리 숫자
    /// - Parameter digit : 자리
    /// - Parameter visible : 의미없는 0은 보이지 않게 스크롤
    private func scrollTo(_ digitScroll: CAScrollLayer, digitNumber: UInt, digit: UInt, visible: Bool) {
        let currentY: CGFloat = digitScroll.presentation()?.value(forKeyPath: "sublayerTransform.translation.y") as? CGFloat ?? 0
        let targetY = visible ? -CGFloat(digitNumber + 1) * digitHeight : 0
        
        digitScroll.removeAnimation(forKey: "scroll")
        
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = animationDuration + TimeInterval(digit) * animationInerval
        animation.fromValue = currentY
        animation.toValue = targetY
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        digitScroll.add(animation, forKey: "scroll")
    }
}
