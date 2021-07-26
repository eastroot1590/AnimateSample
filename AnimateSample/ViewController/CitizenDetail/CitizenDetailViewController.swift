//
//  CitizenDetailViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 상세정보 화면
class CitizenDetailViewController: UIViewController, TransitioningInteractable {
    /// 상세 정보 view
    var detailForm: CitizenDetailForm!
    
    /// 뒤로가기 버튼
    let backButton = UIButton()
    
    /// 주민 정보
    let citizenInfo: CitizenInfo
    
    init(citizenInfo: CitizenInfo) {
        self.citizenInfo = citizenInfo
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // detail form
        detailForm = CitizenDetailForm(frame: view.frame, profile: UIImage(named: citizenInfo.profileImage))
        detailForm.backgroundColor = .systemBackground
        detailForm.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailForm)
        NSLayoutConstraint.activate([
            detailForm.topAnchor.constraint(equalTo: view.topAnchor),
            detailForm.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailForm.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // back button
        backButton.setImage(UIImage(named: "arrowLeftW48"), for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        backButton.frame.size = backButton.imageView?.frame.size ?? CGSize(width: 48, height: 48)
        backButton.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.layer.cornerRadius = 25
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: backButton.imageView?.frame.width ?? 48),
            backButton.heightAnchor.constraint(equalToConstant: backButton.imageView?.frame.height ?? 48)
        ])
        
        backButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backButton.isHidden = false
        
        // fatch data
        detailForm.fatch(citizenInfo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        detailForm.setContentOffset(CGPoint(x: -view.safeAreaInsets.left, y: -view.safeAreaInsets.top), animated: true)
        detailForm.showsVerticalScrollIndicator = false
        
        backButton.isHidden = true
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: TransitioningInteractable
    var pushAnimator: UIViewControllerAnimatedTransitioning?
    var popAnimator: UIViewControllerAnimatedTransitioning?
    
    var threshold: CGFloat = 0.5
    
    var interactiveTransitioning: Bool = false
    
    func animatedPushAnimator() -> UIViewControllerAnimatedTransitioning? {
        return pushAnimator
    }
    
    func animatedPopAnimator() -> UIViewControllerAnimatedTransitioning? {
        return popAnimator
    }
    
    func interactiveDidBegin() {
        guard let homeNavigation = view.rootNavigationController as? HomeNavigationController else {
            return
        }
        
        interactiveTransitioning = true
        homeNavigation.popViewController(animated: true)
    }
    
    func interactivePopAnimator() -> UIPercentDrivenInteractiveTransition? {
        guard interactiveTransitioning else {
            return nil
        }
        
        return popAnimator as? UIPercentDrivenInteractiveTransition
    }
    
    func interactiveDidChange(_ percent: CGFloat) {
        guard let interactiveAnimator = popAnimator as? UIPercentDrivenInteractiveTransition else {
            return
        }
        
        interactiveAnimator.update(percent)
    }
    
    func interactiveDidEnd(_ percent: CGFloat) {
        guard let interactiveAnimator = popAnimator as? UIPercentDrivenInteractiveTransition else {
            return
        }
        
        interactiveTransitioning = false
        percent > 0.5 ? interactiveAnimator.finish() : interactiveAnimator.cancel()
    }
    
    func interactiveDidCanceled(_ percent: CGFloat) {
        guard let interactiveAnimator = popAnimator as? UIPercentDrivenInteractiveTransition else {
            return
        }
        
        interactiveTransitioning = false
        interactiveAnimator.cancel()
    }
}
