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
        
        let stack = VStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        number.number = 12345678.9
        stack.push(number, spacing: 10)

        let label = UILabel()
        label.text = "나도 해보시지"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        stack.push(label, spacing: 10)
        
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
