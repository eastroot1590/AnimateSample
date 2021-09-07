//
//  TestDetailViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/02.
//

import UIKit

class TestDetailViewController: UIViewController, TransitioningAnimatable {
    var pushAnimator: UIViewControllerAnimatedTransitioning?
    var popAnimator: UIViewControllerAnimatedTransitioning?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touched)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("test view will appear navigation bar hidden")

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func touched() {
        navigationController?.popViewController(animated: true)
    }
    
    func animatedPushAnimator() -> UIViewControllerAnimatedTransitioning? {
        return pushAnimator
    }
    
    func animatedPopAnimator() -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    
}
