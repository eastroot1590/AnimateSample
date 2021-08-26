//
//  ChartERView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/26.
//

import UIKit

/// 차트를 표현하는 View
/// TODO: 일단 LineChart를 만들고 나중에 추상화 시키자.
class ChartERView: UIScrollView {
    // 차트 옵션
    // 여백
    var chartInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
    
    // 가로 길이
    var chartWidth: CGFloat {
        guard let elements = chartElements else {
            return 0
        }
        
        return CGFloat(elements.values.count - 1) * spaceInterValues
    }
    
    // 보이는 값 개수
    var visibleValueCount: Int = 5
    
    // 각 값 사이의 거리
    var minimumSpacingInterValues: CGFloat = 50
    
    // 데이터
    private var chartElements: ChartERElements? = nil
    
    var minValue: Float = 0
    var maxValue: Float = 0
    var valueRange: Float {
        maxValue - minValue
    }
    
    // view
    // 스크롤 기능을 위해 추가한 투명한 view
    let contentView: UIView = UIView()
    var contentWidth: CGFloat {
        chartInset.left + chartWidth + chartInset.right
    }
    var contentWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // 실제 차트가 그려지는 view
    let overlayView: UIView = UIView()
    
    // 차트
    let chartLayer = CAShapeLayer()
    let chartPath = UIBezierPath()
    
    // 스크롤 width를 계산하기 위한 spacing
    private var spaceInterValues: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentWidthConstraint
        ])
        
        overlayView.frame = bounds
        overlayView.alpha = 0.5
        overlayView.isUserInteractionEnabled = false
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(overlayView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        contentWidthConstraint.constant = contentWidth
        contentSize = CGSize(width: contentWidth, height: frame.height)
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let elements = self.chartElements else {
            return
        }
        
        overlayView.frame.origin = CGPoint(x: contentOffset.x, y: contentOffset.y)
        
        // update path
        var virtualIndex = Int(contentOffset.x / spaceInterValues)
        virtualIndex = max(min(virtualIndex, elements.values.count - 1), 0)
        let alpha = Float(contentOffset.x / spaceInterValues) - Float(virtualIndex)
        var visibleValues: [Float] = Array(repeating: 0, count: visibleValueCount)
        let spacing = (frame.width - chartInset.left - chartInset.right) / CGFloat(visibleValueCount - 1)
        
        let path = UIBezierPath()
        var x = chartInset.left
        
        for index in 0 ..< visibleValueCount {
            if virtualIndex + index < elements.values.count - 1 {
                // 다음 값이랑 거리를 계산해서 저장
                visibleValues[index] = lerp(elements.values[virtualIndex + index], elements.values[virtualIndex + index + 1], alpha: Float(alpha))
            } else {
                // 마지막 값을 저장
                visibleValues[index] = elements.values.last ?? 0
            }
            
            let yOffset = (visibleValues[index] - minValue) / valueRange
            let y = chartInset.top + CGFloat(1 - yOffset) * (frame.height - chartInset.top - chartInset.bottom)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            x += max(minimumSpacingInterValues, spacing)
        }
        
        chartLayer.path = path.cgPath
    }
    
    func addElement(_ elements: ChartERElements) {
        guard let currentMinValue = elements.values.min(),
              let currentMaxValue = elements.values.max() else {
            return
        }
        
        // update max min
        minValue = currentMinValue
        maxValue = currentMaxValue
        
        // generate layer
        chartPath.move(to: .zero)
        
        let spacing = (frame.width - chartInset.left - chartInset.right) / CGFloat(visibleValueCount - 1)
        spaceInterValues = max(spacing, minimumSpacingInterValues)
        
        var x: CGFloat = chartInset.left
        
        for _ in 0 ..< visibleValueCount {
            let y = frame.height - chartInset.bottom
            chartPath.addLine(to: CGPoint(x: x, y: y))
            
            x += max(spacing, minimumSpacingInterValues)
        }
        
        chartLayer.fillColor = nil
        chartLayer.strokeColor = UIColor.systemBlue.cgColor
        chartLayer.lineWidth = 2
        chartLayer.path = chartPath.cgPath
        
        overlayView.layer.addSublayer(chartLayer)
        
        chartElements = elements
        
        // original chart
        let originChartLayer = CAShapeLayer()
        originChartLayer.fillColor = nil
        originChartLayer.strokeColor = UIColor.systemRed.cgColor
        
        let path = UIBezierPath()
        x = chartInset.left
        
        for index in 0 ..< elements.values.count {
            let yOffset = (elements.values[index] - minValue) / valueRange
            let y = chartInset.top + CGFloat(1 - yOffset) * (frame.height - chartInset.top - chartInset.bottom)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            x += spaceInterValues
        }
        
        originChartLayer.path = path.cgPath
        contentView.layer.addSublayer(originChartLayer)
    }
    
    private func lerp(_ lhs: Float, _ rhs: Float, alpha: Float) -> Float {
        return lhs * (1 - alpha) + rhs * alpha
    }
}
