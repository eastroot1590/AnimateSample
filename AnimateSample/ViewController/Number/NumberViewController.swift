//
//  NumberViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/07.
//

import UIKit

class NumberViewController: UIViewController {
    let number = Number(integerDigitCount: 5, floatingDigitCount: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        number.font = .systemFont(ofSize: 24)
        number.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(number)
        NSLayoutConstraint.activate([
            number.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            number.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch)))
    }
    
    @objc func handleTouch() {
        number.number = Double.random(in: 0 ..< 100000)
    }
}
