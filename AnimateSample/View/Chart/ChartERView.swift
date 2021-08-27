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
        
        return CGFloat(elements.values.count - 1) * spacingInterValues
    }
    
    // 보이는 값 개수
    var visibleValueCount: Int = 5
    
    // 차트 포인트 크기
    var chartPointRadius: CGFloat = 5
    
    // 각 값 사이의 거리
    var minimumSpacingInterValues: CGFloat = 50
    
    // 차트 선 곡률
    // 0~1
    var chartCurveRate: CGFloat = 1
    
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
    let chartLineLayer = CAShapeLayer()
    let chartPointLayer = CAShapeLayer()
    
    // 스크롤 width를 계산하기 위한 spacing
    private var spacingInterValues: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsHorizontalScrollIndicator = false
        delegate = self
        decelerationRate = .fast
        
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
        overlayView.isUserInteractionEnabled = false
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(overlayView)
        
        // 차트 Layer
        chartLineLayer.fillColor = nil
        chartLineLayer.strokeColor = UIColor.systemBlue.cgColor
        chartLineLayer.lineWidth = 4
        overlayView.layer.addSublayer(chartLineLayer)
        
        chartPointLayer.fillColor = UIColor.systemBlue.cgColor
        chartPointLayer.strokeColor = UIColor.white.cgColor
        chartPointLayer.lineWidth = 2
        overlayView.layer.addSublayer(chartPointLayer)
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
        
        // 선계산
        var virtualIndex = Int(contentOffset.x / spacingInterValues)
        virtualIndex = max(min(virtualIndex, elements.values.count - 1), 0)
        let valueAlpha = Float(contentOffset.x / spacingInterValues) - Float(virtualIndex)
        
        var visibleValues: [Float] = Array(repeating: 0, count: visibleValueCount)
        var x = chartInset.left
        var lastPoint: CGPoint = .zero
        
        // Path 그리기
        let linePath = UIBezierPath()
        let pointPath = UIBezierPath()
        
        for index in 0 ..< visibleValueCount {
            if virtualIndex + index < elements.values.count - 1 {
                // 다음 값이랑 거리를 계산해서 저장
                visibleValues[index] = lerp(elements.values[virtualIndex + index], elements.values[virtualIndex + index + 1], alpha: Float(valueAlpha))
            } else {
                // 마지막 값을 저장
                visibleValues[index] = elements.values.last ?? 0
            }
            
            let yOffset = (visibleValues[index] - minValue) / valueRange
            let y = chartInset.top + CGFloat(1 - yOffset) * (frame.height - chartInset.top - chartInset.bottom)
            
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
            } else {
                let controlOffset = spacingInterValues / 2 * chartCurveRate
                linePath.addCurve(to: CGPoint(x: x, y: y), controlPoint1: CGPoint(x: lastPoint.x + controlOffset, y: lastPoint.y), controlPoint2: CGPoint(x: x - controlOffset, y: y))
            }
            
            let radius = chartPointRadius
            pointPath.move(to: CGPoint(x: x + radius, y: y))
            pointPath.addArc(withCenter: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            lastPoint = CGPoint(x: x, y: y)
            
            x += spacingInterValues
        }
        
        chartLineLayer.path = linePath.cgPath
        chartPointLayer.path = pointPath.cgPath
    }
    
    func addElement(_ elements: ChartERElements) {
        guard let currentMinValue = elements.values.min(),
              let currentMaxValue = elements.values.max() else {
            return
        }
        
        // update max min
        minValue = currentMinValue
        maxValue = currentMaxValue
        
        // recalculate spacingInterValues
        let spacing = (frame.width - chartInset.left - chartInset.right) / CGFloat(visibleValueCount - 1)
        if spacing > minimumSpacingInterValues {
            spacingInterValues = spacing
        } else {
            spacingInterValues = minimumSpacingInterValues
        }
        
        // store elements
        chartElements = elements
        
        // original chart
        // uncomment below to show original chart
        overlayView.alpha = 0.5

        let originChartLayer = CAShapeLayer()
        originChartLayer.fillColor = nil
        originChartLayer.strokeColor = UIColor.systemRed.cgColor

        let path = UIBezierPath()
        var x = chartInset.left

        var lastPoint: CGPoint = .zero

        for index in 0 ..< elements.values.count {
            let yOffset = (elements.values[index] - minValue) / valueRange
            let y = chartInset.top + CGFloat(1 - yOffset) * (frame.height - chartInset.top - chartInset.bottom)

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addCurve(to: CGPoint(x: x, y: y), controlPoint1: CGPoint(x: lastPoint.x + spacingInterValues / 2, y: lastPoint.y), controlPoint2: CGPoint(x: x - spacingInterValues / 2, y: y))
            }

            lastPoint = CGPoint(x: x, y: y)

            x += spacingInterValues
        }

        originChartLayer.path = path.cgPath
        contentView.layer.addSublayer(originChartLayer)
        // original chart end
    }
    
    private func lerp(_ lhs: Float, _ rhs: Float, alpha: Float) -> Float {
        return lhs * (1 - alpha) + rhs * alpha
    }
}

extension ChartERView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let elements = chartElements else {
            return
        }

        var virtualIndex = Int(((targetContentOffset.pointee.x - chartInset.left) / spacingInterValues).rounded())
        virtualIndex = max(min(virtualIndex, elements.values.count - 1), 0)

        targetContentOffset.initialize(to: CGPoint(x: CGFloat(virtualIndex) * spacingInterValues, y: 0))
    }
}
