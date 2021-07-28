//
//  DigitScrollLayer.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/28.
//

import UIKit

class DigitScrollLayer: CAScrollLayer {
    let digit: Int
    var number: Int?
    
    init(digit: Int) {
        self.digit = digit
        
        super.init()
        
        let font = UIFont.systemFont(ofSize: 16)
        let width = font.pointSize * 0.75
        let height = font.lineHeight
        
        for index in 0...10 {
            let digitLayer = CATextLayer()
            digitLayer.frame = CGRect(origin: CGPoint(x: 0, y: CGFloat(index) * height), size: CGSize(width: width, height: height))
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
        self.digit = 0
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 폰트를 변경한다.
    func setFont(_ font: UIFont) {
        let height = font.lineHeight
        let width = font.pointSize * 0.75
        
        var index: CGFloat = 0
        
        sublayers?.forEach({ sublayer in
            guard let subTextLayer = sublayer as? CATextLayer else {
                return
            }
            
            subTextLayer.frame = CGRect(origin: CGPoint(x: 0, y: index * height), size: CGSize(width: width, height: height))
            subTextLayer.font = font
            subTextLayer.fontSize = font.pointSize
            
            index += 1
        })
    }
    
    /// 오른쪽부터 채우는 레이아웃
    /// 정수부를 표현할 때 사용한다.
    /// - Parameter digitSize : 각 자리 크기
    /// - Parameter totalDigitCount : 표현할 수 있는 최대 자리수
    func layoutRightToLeft(_ digitSize: CGSize, totalDigitCount: Int) {
        frame = CGRect(origin: CGPoint(x: CGFloat(totalDigitCount - digit) * digitSize.width - digitSize.width, y: 0), size: digitSize)
    }
    
    /// 왼쪽부터 채우는 레이아웃
    /// 왼쪽부터 채우는 경우는 실수부를 표현할 때 인데, 실수부는 소숫점 이후로 그리기 때문에 소숫점 크기만큼 offset을 설정한다.
    /// - Parameter digitSize : 각 자리 크기
    /// - Parameter totalDigitCount : 표현할 수 있는 최대 자리수
    /// - Parameter offset : 소숫점 가로 크기
    func layoutLeftToRight(_ digitSize: CGSize, totalDigitCount: Int, offset: CGFloat = 0) {
        frame = CGRect(origin: CGPoint(x: CGFloat(totalDigitCount) * digitSize.width + offset + CGFloat(digit) * digitSize.width, y: 0), size: digitSize)
    }
    
    /// 스크롤 애니메이션을 재생한다.
    /// 이미 애니메이션 중이라면 해당 위치부터 다시 새로운 애니메이션을 재생한다.
    /// - Parameter to : 해당 자리 숫자. nil이라면 공백을 표시하도록 스크롤한다.
    /// - Parameter duration : 애니메이션 최소 재생시간
    /// - Parameter offset : 애니메이션 재생시간 차이
    func scroll(to number: Int?, duration: TimeInterval, offset: TimeInterval) {
        self.number = number
        
        let currentY: CGFloat = presentation()?.value(forKeyPath: "sublayerTransform.translation.y") as? CGFloat ?? 0
        let height: CGFloat = sublayers?.first?.frame.height ?? 0
        let targetY = -CGFloat((number ?? -1) + 1) * height
        
        removeAnimation(forKey: "scroll")
        
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = duration + offset
        animation.fromValue = currentY
        animation.toValue = targetY
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        add(animation, forKey: "scroll")
    }
}
