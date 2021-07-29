//
//  TestViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class TestViewController: UIViewController {
    let number = Number(integerDigitCount: 8, floatingDigitCount: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "테스트"
        
        view.backgroundColor = .systemBackground
        
        number.number = 12345678.9
        number.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(number)
        NSLayoutConstraint.activate([
            number.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            number.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touched)))
    }
    
    @objc func touched() {
        let newNumber = Double.random(in: 0...99999999)
        print("newNumber \(newNumber)")
        
//        number.font = .systemFont(ofSize: CGFloat.random(in: 16...32))
        number.number = newNumber
        number.font = .systemFont(ofSize: CGFloat.random(in: 16...32))
    }
}
