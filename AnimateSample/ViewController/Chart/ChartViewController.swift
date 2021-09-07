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
    }
}