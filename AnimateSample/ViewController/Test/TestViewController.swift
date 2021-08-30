//
//  TestViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        title = "테스트"
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        let chart = ChartERView(frame: CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: view.frame.width, height: 200)))
        chart.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        chart.setElements(ChartERElements(name: "hello", values: [13, 5, 7, 2, -4, 15, -21, -21, -21, 1, 5, 17]))
        chart.setName(["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월"])
        view.addSubview(chart)
    }
}
