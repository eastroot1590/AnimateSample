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
        chart.addElement(ChartERElements(name: "hello", values: [13, 5, 2, 3, 1, 6, 21, 1, 5, 8]))
        view.addSubview(chart)
    }
}
