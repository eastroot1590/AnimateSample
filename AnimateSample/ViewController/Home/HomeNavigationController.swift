//
//  HomeNavigationController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 최상위 NavigationController
class HomeNavigationController: UINavigationController {
    weak var transitioningViewController: TransitioningAnimatable?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

// MARK: UINavigationControllerDelegate
extension HomeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let transitioningViewController = self.transitioningViewController else {
            return nil
        }
        
        switch operation {
        case .push:
            return transitioningViewController.pushAnimator()
            
        default:
            return nil
        }
    }
}
