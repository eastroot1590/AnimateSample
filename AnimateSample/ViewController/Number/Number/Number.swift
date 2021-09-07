//
//  Number.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class Number: UIView {
    // MARK: Property
    var font: UIFont = .systemFont(ofSize: 16) {
        didSet {
            fontChanged()
        }
    }
    
    var number: Double = 0 {
        didSet {
            numberChanged()
        }
    }
    
    var animationDuration: TimeInterval = 1
    var animationInterval: TimeInterval = 0.2
    
    /// 정수부 자리수
    let integerDigitCount: Int
    
    /// 실수부 자리수
    let floatingDigitCount: Int
    
    /// 가장 우측부터 각 자리 정수 숫자를 표시한다.
    /// - [0] : 가장 작은 자리
    /// - [max] : 가장 큰 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostLeftDigit() 함수를 통해 계산)
    private var integerDigits: [DigitScrollLayer] = []
    
    /// 천 단위 구분 콤마
    private var commas: [CATextLayer] = []
    
    /// 소숫점
    private var decimalPoint: CATextLayer?
    
    /// 가장 좌측부터 각 자리 실수 숫자를 표시한다.
    /// - [0] : 가장 큰 자리
    /// - [max] : 가장 작은 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostRightDigit() 함수를 통해 계산)
    private var floatingDigits: [DigitScrollLayer] = []
    
    /// 숫자 크기
    private var digitSize: CGSize {
        CGSize(width: font.pointSize * 0.75, height: font.lineHeight)
    }
    
    /// 기호 크기
    private var symbolSize: CGSize {
        CGSize(width: font.pointSize * 0.5, height: font.lineHeight)
    }
    
    /// 투명도 gradient
    private var gradientLayer = CAGradientLayer()
    
    /// 컨텐츠 크기
    override var intrinsicContentSize: CGSize {
        frame.size
    }
    
    // MARK: Initialize
    init(integerDigitCount: Int, floatingDigitCount: Int = 0) {
        self.integerDigitCount = max(0, integerDigitCount)
        self.floatingDigitCount = max(0, floatingDigitCount)
        
        super.init(frame: .zero)
        
        // 정수부
        for _ in 0..<integerDigitCount {
            let digitScroll = DigitScrollLayer(font: font, digitSize: digitSize)
            
            layer.addSublayer(digitScroll)
            integerDigits.append(digitScroll)
        }
        
        // 콤마
        for _ in 0..<(integerDigitCount - 1) / 3 {
            let commaLayer = CATextLayer()
            commaLayer.string = ","
            commaLayer.alignmentMode = .center
            commaLayer.contentsScale = UIScreen.main.scale
            commaLayer.foregroundColor = UIColor.black.cgColor
            // 바로 layer에 추가하지 않음
            
            self.commas.append(commaLayer)
        }
        
        // 소숫점
        if floatingDigitCount > 0 {
            let decimalPoint = CATextLayer()
            decimalPoint.string = "."
            decimalPoint.alignmentMode = .center
            decimalPoint.contentsScale = UIScreen.main.scale
            decimalPoint.foregroundColor = UIColor.black.cgColor
            layer.addSublayer(decimalPoint)
            
            self.decimalPoint = decimalPoint
        }
        
        // 실수부
        for _ in 0..<floatingDigitCount {
            let digitScroll = DigitScrollLayer(font: font, digitSize: digitSize)
            layer.addSublayer(digitScroll)
            
            floatingDigits.append(digitScroll)
        }
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 0.2, 0.8, 1]
        if #available(iOS 13.0, *) {
            gradientLayer.colors = [
                CGColor(gray:0, alpha: 0),
                CGColor(gray:0, alpha: 1),
                CGColor(gray:0, alpha: 1),
                CGColor(gray:0, alpha: 0)
            ]
        } else {
            gradientLayer.colors = [
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1).cgColor,
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1).cgColor,
                UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0).cgColor
            ]
        }
        layer.addSublayer(gradientLayer)
        layer.mask = gradientLayer
        
        // layout
        fontChanged()
        numberChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 각 자리 숫자를 갱신하고 스크롤 애니메이션을 재생한다.
    private func numberChanged() {
        // 콤마 초기화
        commas.forEach { $0.removeFromSuperlayer() }
        
        var bValidInteger: Bool = false
        var bValidFloating: Bool = false
        
        // 정수부
        for digit in (0..<integerDigitCount).reversed() {
            let devider = Int(pow(10, Float(digit)))
            let digitNumber = (Int(self.number) / devider) % 10
            if digitNumber > 0 || digit == 0 {
                bValidInteger = true
            }
            
            // 콤마 추가
            if bValidInteger,
               digit > 0 && digit % 3 == 0 {
                let commaDigit = digit / 3 - 1
                layer.addSublayer(commas[commaDigit])
            }
            
            integerDigits[digit].setNumber(bValidInteger ? digitNumber : -1, duration: animationDuration, offset: TimeInterval(digit) * animationInterval)
        }
        
        // 실수부
        for digit in (0..<floatingDigitCount).reversed() {
            let multiplier = Double(pow(10, Float(digit + 1)))
            let digitNumber = Int(self.number * multiplier) % 10
            if digitNumber > 0 || digit == 0 {
                bValidFloating = true
            }
            
            floatingDigits[digit].setNumber(bValidFloating ? digitNumber : -1, duration: animationDuration, offset: TimeInterval(digit) * animationInterval)
        }
    }
    
    /// 폰트가 새로 설정되었기 때문에 전체 크기를 다시 계산한다.
    private func fontChanged() {
        var newWidth: CGFloat = 0
        var commaDigit: Int = 0
        
        // 정수부
        for digit in 0..<integerDigitCount {
            if isCommaDigit(digit) {
                // 콤마 (R to L)
                let offset = CGFloat(commas.count - commaDigit) * symbolSize.width
                let minX = CGFloat(integerDigitCount - digit) * digitSize.width - symbolSize.width
                
                commas[commaDigit].frame = CGRect(origin: CGPoint(x: minX + offset, y: 0), size: symbolSize)
                commas[commaDigit].font = font
                commas[commaDigit].fontSize = font.pointSize
                
//                totalSymbolWidth += symbolSize.width
                newWidth += symbolSize.width
                commaDigit += 1
            }
            
            // TODO: 현재 콤마 개수가 아니라 전체 콤마 개수로 계산하는 점이 마음에 안든다.
            integerDigits[digit].setFont(font, digitSize: digitSize)
            
            let minX = CGFloat(integerDigitCount - digit) * digitSize.width - digitSize.width
            let offset = CGFloat(commas.count - digit / 3) * symbolSize.width
            
            integerDigits[digit].frame = CGRect(origin: CGPoint(x: minX + offset, y: 0), size: digitSize)
            
            newWidth += digitSize.width
        }
        
        // 소숫점
        if floatingDigitCount > 0 {
            decimalPoint?.font = font
            decimalPoint?.fontSize = font.pointSize
            decimalPoint?.frame = CGRect(origin: CGPoint(x: newWidth, y: 0), size: symbolSize)
            
            newWidth += symbolSize.width
        }
        
        // 실수부
        for digit in 0..<floatingDigitCount {
            floatingDigits[digit].frame = CGRect(origin: CGPoint(x: newWidth, y: 0), size: digitSize)
            floatingDigits[digit].setFont(font, digitSize: digitSize)
            
            newWidth += digitSize.width
        }
        
        // 크기 재설정
        frame.size = CGSize(width: newWidth, height: digitSize.height)
        gradientLayer.frame = bounds
        
        invalidateIntrinsicContentSize()
    }
    
    private func isCommaDigit(_ digit: Int) -> Bool {
        return digit > 0 && digit % 3 == 0
    }
}
