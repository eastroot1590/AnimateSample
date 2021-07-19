//
//  CitizenDetailViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 상세정보 화면
class CitizenDetailViewController: UIViewController {
    var transitioningPushAnimator: UIViewControllerAnimatedTransitioning?
    var transitioningPopAnimator: UIViewControllerAnimatedTransitioning?
    
    let profileImage = UIImageView()
    
    init(citizen: CitizenMinimumData) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        
        profileImage.image = UIImage(named: citizen.profileImage)
        profileImage.contentMode = .scaleAspectFit
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        let profileImageHeight = profileImage.heightAnchor.constraint(equalTo: view.heightAnchor)
        profileImageHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor),
            profileImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileImageHeight,
            profileImage.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
        ])
        
        // TODO: load detail data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
}

// MARK: TransitioningAnimatable
extension CitizenDetailViewController: TransitioningAnimatable {
    func pushAnimator() -> UIViewControllerAnimatedTransitioning? {
        return transitioningPushAnimator
    }
    
    func popAnimator() -> UIViewControllerAnimatedTransitioning? {
        return transitioningPopAnimator
    }
}
