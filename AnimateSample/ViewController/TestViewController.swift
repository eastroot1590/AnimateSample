//
//  TestViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class TestViewController: UIViewController {
    let stack = VStackView()
    
//    let number = Number(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "테스트"
        
        view.backgroundColor = .systemBackground
        view.addSubview(stack)
        
        for _ in 0..<1 {
            let number = Number(10)
            number.setFont(.boldSystemFont(ofSize: 24))
            number.setNumber(UInt.random(in: 0...9999999999))
            
            stack.push(number, spacing: 10)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touched)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let leftTop: CGPoint = CGPoint(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top)
        
        stack.frame.origin = leftTop
        stack.frame.size = CGSize(width: view.frame.width, height: stack.frame.height)
    }
    
    @objc func touched() {
        for node in stack.stack {
            if let number = node.view as? Number {
                let newNumber = UInt.random(in: 0...9999999999)
                print("newNumber: \(newNumber)")
                number.setNumber(newNumber)
            }
        }
    }
}
