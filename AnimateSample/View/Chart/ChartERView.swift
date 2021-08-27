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
    // 여백
    var chartInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // 가로 길이
    var chartIntrinsicWidth: CGFloat {
        guard let elements = chartElements else {
            return 0
        }
        
        return CGFloat(elements.values.count - 1) * spacingInterValues
    }
    
    var chartAvailableSize: CGSize {
        let width = frame.width - chartInset.left - chartInset.right - yAxisWidth
        let height = frame.height - chartInset.top - chartInset.bottom - xAxisHeight
        return CGSize(width: width, height: height)
    }
    
    var chartType: ChartERType = .curvedLine
    
    // 보이는 값 개수
    var visibleValueCount: Int = 7
    
    // 차트 포인트 크기
    var chartPointRadius: CGFloat = 5
    
    // 각 값 사이의 거리
    var minimumSpacingInterValues: CGFloat = 10
    
    // 차트 선 곡률
    // 0~1
    var chartCurveRate: CGFloat = 0.8
    
    // 축
    var yAxisWidth: CGFloat = 40
    var xAxisHeight: CGFloat = 30
    
    // 데이터
    private var chartElements: ChartERElements? = nil
    
    var visibleValues: [Float] = []
    
    var minValue: Float = 0
    var maxValue: Float = 0
    
    // view
    // 스크롤 기능을 위해 추가한 투명한 view
    let contentView: UIView = UIView()
    var contentWidth: CGFloat {
        yAxisWidth + chartInset.left + chartIntrinsicWidth + chartInset.right
    }
    var contentWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // 실제 차트가 그려지는 view
    let chartER: UIView = UIView()
    
    // 차트
    let chartLineLayer = CAShapeLayer()
    let chartPointLayer = CAShapeLayer()
    let chartAxisLayer = CAShapeLayer()
    var chartYValueLayers: [CATextLayer] = []
    var chartXValueLayers: [CATextLayer] = []
    
    let shadowChartLayer = CAShapeLayer()
    
    // 스크롤 width를 계산하기 위한 spacing
    private var spacingInterValues: CGFloat = 0
    
    private var chartMinX: CGFloat {
        yAxisWidth + chartInset.left
    }

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
        
        chartER.frame = bounds
        chartER.isUserInteractionEnabled = false
        chartER.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(chartER)
        
        // 차트 Layer
        chartLineLayer.fillColor = nil
        chartLineLayer.strokeColor = UIColor.systemBlue.cgColor
        chartLineLayer.lineWidth = 3
        chartER.layer.addSublayer(chartLineLayer)
        
        chartPointLayer.fillColor = UIColor.systemBlue.cgColor
        chartPointLayer.strokeColor = UIColor.white.cgColor
        chartPointLayer.lineWidth = 2
        chartER.layer.addSublayer(chartPointLayer)

        chartAxisLayer.fillColor = nil
        chartAxisLayer.strokeColor = UIColor.gray.cgColor
        chartAxisLayer.lineWidth = 1
        chartER.layer.addSublayer(chartAxisLayer)
        
        shadowChartLayer.fillColor = nil
        shadowChartLayer.strokeColor = UIColor.systemRed.cgColor
        contentView.layer.addSublayer(shadowChartLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        contentWidthConstraint.constant = contentWidth
        contentSize = CGSize(width: contentWidth, height: chartER.frame.height - adjustedContentInset.top)
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chartER.frame.origin = CGPoint(x: contentOffset.x, y: contentOffset.y)
        
        let linePath = UIBezierPath()
        let pointPath = UIBezierPath()
        drawChartLayer(linePath: linePath, pointPath: pointPath)
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
        let spacing = chartAvailableSize.width / CGFloat(visibleValueCount - 1)
        if spacing > minimumSpacingInterValues {
            spacingInterValues = spacing
        } else {
            spacingInterValues = minimumSpacingInterValues
        }
        
        // store elements
        chartElements = elements
        
        // initialize visible values
        visibleValues = Array(repeating: 0, count: visibleValueCount)
        
        initializeAxisLayer()
        
        // original chart
        // uncomment below to see original chart
        drawShadowChart()
        // original chart end
    }
    
    private func initializeAxisLayer() {
        // axis
        let axisPath = UIBezierPath()
        axisPath.move(to: CGPoint(x: yAxisWidth, y: 0))
        axisPath.addLine(to: CGPoint(x: yAxisWidth, y: frame.height - xAxisHeight))
        axisPath.addLine(to: CGPoint(x: frame.width - chartInset.right, y: frame.height - xAxisHeight))
        chartAxisLayer.path = axisPath.cgPath
        
        chartYValueLayers.forEach { $0.removeFromSuperlayer() }
        chartYValueLayers = []
        
        // y axis 라벨
        for index in 0 ..< 4 {
            let alpha = Float(index) / 3
            let value = lerp(maxValue, minValue, alpha)
            
            let y = lerp(chartInset.top, chartInset.top + chartAvailableSize.height, CGFloat(alpha))
            
            let yValueLayer = CATextLayer()
            yValueLayer.string = "\(Int(value))"
            yValueLayer.frame = CGRect(origin: CGPoint(x: 0, y: y - 7), size: CGSize(width: yAxisWidth - 5, height: 14))
            yValueLayer.font = UIFont.systemFont(ofSize: 8)
            yValueLayer.alignmentMode = .right
            yValueLayer.fontSize = 12
            yValueLayer.contentsScale = UIScreen.main.scale
            yValueLayer.foregroundColor = UIColor.gray.cgColor
            chartER.layer.addSublayer(yValueLayer)
            chartYValueLayers.append(yValueLayer)
        }
        
        // x axis 라벨
        var x = chartMinX
        for _ in 0 ..< visibleValueCount {
            let y = frame.height - xAxisHeight + 5
            
            let xValueLayer = CATextLayer()
            xValueLayer.string = "nil"
            xValueLayer.frame = CGRect(origin: CGPoint(x: x - 20, y: y), size: CGSize(width: 40, height: xAxisHeight - 5))
            xValueLayer.font = UIFont.systemFont(ofSize: 8)
            xValueLayer.alignmentMode = .center
            xValueLayer.fontSize = 12
            xValueLayer.contentsScale = UIScreen.main.scale
            xValueLayer.foregroundColor = UIColor.gray.cgColor
            
            chartER.layer.addSublayer(xValueLayer)
            chartXValueLayers.append(xValueLayer)
            
            x += spacingInterValues
        }
    }
    
    private func drawChartLayer(linePath: UIBezierPath, pointPath: UIBezierPath? = nil) {
        guard let elements = chartElements else {
            return
        }
        
        let virtualIndex = clamp(Int(contentOffset.x / spacingInterValues), -visibleValueCount, elements.values.count)
        
        var x = chartMinX
        var lastPoint: CGPoint = .zero
        
        for index in 0 ..< visibleValueCount {
            let y = yCoordinate(for: value(for: index))
            
            // line
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
            } else {
                if chartType == .curvedLine {
                    let controlOffset = spacingInterValues / 2 * chartCurveRate
                    linePath.addCurve(to: CGPoint(x: x, y: y), controlPoint1: CGPoint(x: lastPoint.x + controlOffset, y: lastPoint.y), controlPoint2: CGPoint(x: x - controlOffset, y: y))
                } else {
                    linePath.addLine(to: CGPoint(x: x, y: y))
                }
            }
            lastPoint = CGPoint(x: x, y: y)
            
            // point
            let radius = chartPointRadius
            pointPath?.move(to: CGPoint(x: x + radius, y: y))
            pointPath?.addArc(withCenter: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            // update x values
            chartXValueLayers[index].string = "\(virtualIndex + index)"
            
            x += spacingInterValues
        }
    }
    
    private func drawShadowChart() {
        guard let elements = chartElements else {
            return
        }
        
        let linePath = UIBezierPath()
        
        var x = chartMinX
        var lastPoint: CGPoint = .zero

        for index in 0 ..< elements.values.count {
            let y = yCoordinate(for: elements.values[index])

            // line
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
            } else {
                if chartType == .curvedLine {
                    let controlOffset = spacingInterValues / 2 * chartCurveRate
                    linePath.addCurve(to: CGPoint(x: x, y: y), controlPoint1: CGPoint(x: lastPoint.x + controlOffset, y: lastPoint.y), controlPoint2: CGPoint(x: x - controlOffset, y: y))
                    lastPoint = CGPoint(x: x, y: y)
                } else {
                    linePath.addLine(to: CGPoint(x: x, y: y))
                }
            }

            lastPoint = CGPoint(x: x, y: y)

            x += spacingInterValues
        }

        shadowChartLayer.path = linePath.cgPath
    }
    
    private func value(for index: Int) -> Float {
        guard let elements = self.chartElements else {
            return 0
        }
        
        let virtualIndex = Int(contentOffset.x / spacingInterValues)
        let valueAlpha = contentOffset.x / spacingInterValues - CGFloat(virtualIndex)
        let maxIndex = elements.values.count - 1
        
        if contentOffset.x < 0 {
            if virtualIndex + index > 0 {
                return lerp(elements.values[virtualIndex + index], elements.values[virtualIndex + index - 1], Float(abs(valueAlpha)))
            } else {
                return elements.values.first ?? 0
            }
        }
        
        if virtualIndex + index < maxIndex {
            // 다음 값이랑 거리를 계산
            return lerp(elements.values[virtualIndex + index], elements.values[virtualIndex + index + 1], Float(valueAlpha))
        } else {
            // 마지막 값
            return elements.values.last ?? 0
        }
    }
    
    private func yCoordinate(for value: Float) -> CGFloat {
        let yOffset = (value - minValue) / (maxValue - minValue)
        return chartInset.top + CGFloat(1 - yOffset) * chartAvailableSize.height + adjustedContentInset.top
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
