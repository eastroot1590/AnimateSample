//
//  ChartViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class ChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        let chart = ChartView(frame: CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: view.frame.width, height: 200)))
        chart.setElements(ChartElements(name: "hello", values: [13, 5, 7, 2, -4, 15, -21, -21, -21, 1, 5, 17]))
        chart.setName(["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"])
        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chart.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        let charter = ChartERView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: view.frame.width, height: 200)))
        charter.builder = LineChartERBuilder()
        charter.series = ChartERSeries(name: "hello", values: [1, 5, 17, 2, 4, 5, 21, 7, 1, 18, 5, 7])
        charter.xAxisNames = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
        charter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charter)
        NSLayoutConstraint.activate([
            charter.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 50),
            charter.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charter.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charter.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        let barChart = ChartERView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: view.frame.width, height: 200)))
        barChart.builder = BarChartERBuilder(xAxisLabelCount: 4, yAxisLabelCount: 3)
        barChart.series = ChartERSeries(name: "hello", values: [1, 5, 17, 2, 4, 5, 21, 7, 1, 18, 5, 7])
        barChart.xAxisNames = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
        barChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChart)
        NSLayoutConstraint.activate([
            barChart.topAnchor.constraint(equalTo: charter.bottomAnchor, constant: 50),
            barChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barChart.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
