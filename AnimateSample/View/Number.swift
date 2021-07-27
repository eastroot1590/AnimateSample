//
//  Number.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class Number: UIView {
    let integerDigitCount: Int
    let floatingDigitCount: Int
    
    /// 가장 우측부터 각 자리 정수 숫자를 표시한다.
    /// - [0] : 가장 작은 자리
    /// - [max] : 가장 큰 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostLeftDigit() 함수를 통해 계산)
    var integerDigits: [CAScrollLayer] = []
    
    var decimalPoint: CATextLayer?
    
    /// 가장 좌측부터 각 자리 실수 숫자를 표시한다.
    /// - [0] : 가장 큰 자리
    /// - [max] : 가장 작은 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostRightDigit() 함수를 통해 계산)
    var floatingDigits: [CAScrollLayer] = []
        
    var digitWidth: CGFloat {
        font.pointSize * 0.75
    }
    var digitHeight: CGFloat {
        font.lineHeight
    }
    var symbolWidth: CGFloat {
        font.pointSize * 0.5
    }
    
    var animationDuration: TimeInterval = 1
    var animationInerval: TimeInterval = 0.2
    
    private var font: UIFont = .systemFont(ofSize: 16)
    
    private var number: Double = 0
//    private var integerOfNumber: Int = 0
//    private var floatingOfNumber: Double = 0
    
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
    
    init(integerDigitCount: Int, floatingDigitCount: Int = 0) {
        self.integerDigitCount = max(0, integerDigitCount)
        self.floatingDigitCount = max(0, floatingDigitCount)
        
        super.init(frame: .zero)
        
        // 정수부
        for _ in 0..<integerDigitCount {
            let digit = digitScroll
            layer.addSublayer(digit)
            
            integerDigits.append(digit)
        }
        
        // 소숫점
        if floatingDigitCount > 0 {
            let decimalPoint = CATextLayer()
            decimalPoint.string = "."
            decimalPoint.alignmentMode = .center
            decimalPoint.contentsScale = UIScreen.main.scale
            decimalPoint.fontSize = font.pointSize
            decimalPoint.font = font
            decimalPoint.foregroundColor = UIColor.black.cgColor
            layer.addSublayer(decimalPoint)
            
            self.decimalPoint = decimalPoint
        }
        
        // 실수부
        for _ in 0..<floatingDigitCount {
            let digit = digitScroll
            layer.addSublayer(digit)
            
            floatingDigits.append(digit)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let digitWidth = self.digitWidth
        let digitHeight = self.digitHeight
        
        var symbolWidth: CGFloat = 0
        
        // 소숫점
        if floatingDigitCount > 0 {
            symbolWidth += self.symbolWidth
            decimalPoint?.frame = CGRect(origin: CGPoint(x: CGFloat(integerDigitCount) * digitWidth, y: 0), size: CGSize(width: self.symbolWidth, height: digitHeight))
        }
        
        // 정수부
        for digit in 0..<integerDigitCount {
            integerDigits[digit].frame = CGRect(origin: CGPoint(x: CGFloat(integerDigitCount - digit) * digitWidth - digitWidth, y: 0), size: CGSize(width: digitWidth, height: digitHeight))
        }
        
        // 실수부
        for digit in 0..<floatingDigitCount {
            floatingDigits[digit].frame = CGRect(origin: CGPoint(x: CGFloat(integerDigitCount) * digitWidth + symbolWidth + CGFloat(digit) * digitWidth, y: 0), size: CGSize(width: digitWidth, height: digitHeight))
        }
        
        // 전체
        var newWidth: CGFloat = digitWidth * CGFloat(integerDigitCount)
        newWidth += symbolWidth
        newWidth += digitWidth * CGFloat(floatingDigitCount)
        frame.size = CGSize(width: newWidth, height: digitHeight)
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
        
        // Q: for 루프 안에서 self를 참조하는것 보다 이렇게 한 번 copy 해놓고 쓰는게 좀 더 빠르지 않을까?
        let digitWidth = self.digitWidth
        let digitHeight = self.digitHeight
        
        // 정수부
        integerDigits.forEach { digitScroll in
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
        
        // 소숫점
        decimalPoint?.font = font
        decimalPoint?.fontSize = font.pointSize
        
        // 실수부
        floatingDigits.forEach { digitScroll in
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
    
    func setNumber(_ number: Double) {
        // TODO: floatingDigitCount 이후 자리수는 반올림 하도록 할 수도 있을 것 같다.
        self.number = number
        
        let mostLeftDigit = getMostLeftDigit()
        let mostRightDigit = getMostRightDigit()
        
        // 정수부
        for digit in 0..<integerDigitCount {
            let devider = Int(truncating: NSDecimalNumber(decimal: pow(10, digit)))
            let digitNumber = (Int(self.number) / devider) % 10
            
            scrollTo(integerDigits[Int(digit)], digitNumber: digitNumber, digit: digit, visible: digit <= mostLeftDigit)
        }
        
        // 실수부
        for digit in 0..<floatingDigitCount {
            let multiplier = Double(truncating: NSDecimalNumber(decimal: pow(10, digit + 1)))
            let digitNumber = Int(self.number * multiplier) % 10
            
            scrollTo(floatingDigits[digit], digitNumber: digitNumber, digit: digit, visible: digit <= mostRightDigit)
        }
    }
    
    /// 정수부에서 의미없는 0 자리를 제외한 가장 좌측 자리
    /// - returns : 의미를 가지는 가장 좌측 자리
    private func getMostLeftDigit() -> Int {
        for digit in (0..<integerDigitCount).reversed() {
            let devider = Int(truncating: NSDecimalNumber(decimal: pow(10, digit)))

            let digitNumber = Int(self.number) / devider

            if digitNumber > 0 {
                return digit
            }
        }

        return 0
    }
    
    /// 실수부에서 의미없는 0 자리를 제외한 가장 우측 자리
    /// - returns : 의미를 가지는 가장 우측 자리
    private func getMostRightDigit() -> Int {
        for digit in (0..<floatingDigitCount).reversed() {
            let multiplier = Double(truncating: NSDecimalNumber(decimal: pow(10, digit + 1)))
            
            let digitNumber = Int(self.number * multiplier) % 10
            
            if digitNumber > 0 {
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
    private func scrollTo(_ digitScroll: CAScrollLayer, digitNumber: Int, digit: Int, visible: Bool) {
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
