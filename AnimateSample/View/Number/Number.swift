//
//  Number.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class Number: UIView {
    /// 정수부 자리수
    let integerDigitCount: Int
    
    /// 실수부 자리수
    let floatingDigitCount: Int
    
    /// 가장 우측부터 각 자리 정수 숫자를 표시한다.
    /// - [0] : 가장 작은 자리
    /// - [max] : 가장 큰 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostLeftDigit() 함수를 통해 계산)
    var integerDigits: [DigitScrollLayer] = []
    
    /// 구분 콤마
    var commas: [CATextLayer] = []
    
    /// 소숫점
    var decimalPoint: CATextLayer?
    
    /// 가장 좌측부터 각 자리 실수 숫자를 표시한다.
    /// - [0] : 가장 큰 자리
    /// - [max] : 가장 작은 자리 (0 포함. 0을 포함하지 않는 가장 큰 자리는 getMostRightDigit() 함수를 통해 계산)
    var floatingDigits: [DigitScrollLayer] = []
    
    /// 숫자 크기
    var digitSize: CGSize {
        CGSize(width: font.pointSize * 0.75, height: font.lineHeight)
    }
    
    /// 기호 크기
    var symbolSize: CGSize {
        CGSize(width: font.pointSize * 0.5, height: font.lineHeight)
    }
    
    /// 컨텐츠 가로 넓이
    var numberWidth: CGFloat = 0
    
    /// 컨텐츠 크기
    override var intrinsicContentSize: CGSize {
        CGSize(width: numberWidth, height: digitSize.height)
    }
    
    var animationDuration: TimeInterval = 1
    var animationInterval: TimeInterval = 0.2
    
    private var font: UIFont = .systemFont(ofSize: 16)
    
    private var number: Double = 0
    
    init(integerDigitCount: Int, floatingDigitCount: Int = 0) {
        self.integerDigitCount = max(0, integerDigitCount)
        self.floatingDigitCount = max(0, floatingDigitCount)
        
        super.init(frame: .zero)
        
        // 정수부
        for digit in 0..<integerDigitCount {
            let digitScroll = DigitScrollLayer(digit: digit)
            layer.addSublayer(digitScroll)
            
            integerDigits.append(digitScroll)
        }
        
        // 콤마
        for _ in 0..<(integerDigitCount - 1) / 3 {
            let commaLayer = CATextLayer()
            commaLayer.string = ","
            commaLayer.alignmentMode = .center
            commaLayer.contentsScale = UIScreen.main.scale
            commaLayer.fontSize = font.pointSize
            commaLayer.font = font
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
            decimalPoint.fontSize = font.pointSize
            decimalPoint.font = font
            decimalPoint.foregroundColor = UIColor.black.cgColor
            layer.addSublayer(decimalPoint)
            
            self.decimalPoint = decimalPoint
        }
        
        // 실수부
        for digit in 0..<floatingDigitCount {
            let digitScroll = DigitScrollLayer(digit: digit)
            layer.addSublayer(digitScroll)
            
            floatingDigits.append(digitScroll)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
        
        // 정수부
        integerDigits.forEach { $0.setFont(font) }
        
        // 콤마
        commas.forEach { comma in
            comma.font = font
            comma.fontSize = font.pointSize
        }
        
        // 소숫점
        decimalPoint?.font = font
        decimalPoint?.fontSize = font.pointSize
        
        // 실수부
        floatingDigits.forEach { $0.setFont(font) }
        
        updateContentSize()
    }
    
    func setNumber(_ number: Double) {
        // TODO: floatingDigitCount 이후 자리수는 반올림 하도록 할 수도 있을 것 같다.
        self.number = number

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
            
            integerDigits[digit].scroll(to: bValidInteger ? digitNumber : nil, duration: animationDuration, offset: TimeInterval(digit) * animationInterval)
        }
        
        // 실수부
        for digit in (0..<floatingDigitCount).reversed() {
            let multiplier = Double(pow(10, Float(digit + 1)))
            let digitNumber = Int(self.number * multiplier) % 10
            if digitNumber > 0 || digit == 0 {
                bValidFloating = true
            }
            
            floatingDigits[digit].scroll(to: bValidFloating ? digitNumber : nil, duration: animationDuration, offset: TimeInterval(digit) * animationInterval)
        }
    }
    
    func updateContentSize() {
        var totalSymbolWidth: CGFloat = 0
        
        // 정수부
        for digit in 0..<integerDigitCount {
            if isCommaDigit(digit) {
                // 콤마
                let commaDigit = getCommaDigit(digit)
                let offset = CGFloat(commas.count - commaDigit) * symbolSize.width
                let minX = CGFloat(integerDigitCount - digit) * digitSize.width - symbolSize.width
                commas[commaDigit].frame = CGRect(origin: CGPoint(x: minX + offset, y: 0), size: symbolSize)
                totalSymbolWidth += symbolSize.width
            }
            
            // TODO: 현재 콤마 개수가 아니라 전체 콤마 개수로 계산하는 점이 마음에 안든다.
            let minX = CGFloat(integerDigitCount - digit) * digitSize.width - digitSize.width
            let offset = CGFloat(commas.count - digit / 3) * symbolSize.width
            integerDigits[digit].frame = CGRect(origin: CGPoint(x: minX + offset, y: 0), size: digitSize)
        }
        
        // 소숫점
        if floatingDigitCount > 0 {
            let minX = CGFloat(integerDigitCount) * digitSize.width
            decimalPoint?.frame = CGRect(origin: CGPoint(x: minX + totalSymbolWidth, y: 0), size: symbolSize)
            totalSymbolWidth += symbolSize.width
        }
        
        // 실수부
        for digit in 0..<floatingDigitCount {
            let minX =  CGFloat(integerDigitCount) * digitSize.width + CGFloat(digit) * digitSize.width
            floatingDigits[digit].frame = CGRect(origin: CGPoint(x: minX + totalSymbolWidth, y: 0), size: digitSize)
        }
        
        // 전체
        var newWidth: CGFloat = digitSize.width * CGFloat(integerDigitCount)
        newWidth += totalSymbolWidth
        newWidth += digitSize.width * CGFloat(floatingDigitCount)
        
        numberWidth = newWidth
        frame.size = CGSize(width: newWidth, height: digitSize.height)
        invalidateIntrinsicContentSize()
    }
    
    private func isCommaDigit(_ digit: Int) -> Bool {
        return digit > 0 && digit % 3 == 0
    }
    
    private func getCommaDigit(_ digit: Int) -> Int {
        return digit / 3 - 1
    }
}
