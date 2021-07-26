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
    
    
    /// 상세 폼
    var detailForm: CitizenDetailForm!
    
    /// 뒤로가기 버튼
    let backButton = UIButton()
    
    let citizenInfo: CitizenInfo
    
    init(citizenInfo: CitizenInfo) {
        self.citizenInfo = citizenInfo
        
        super.init(nibName: nil, bundle: nil)
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
        backButton.setTitle("<", for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        backButton.frame.size = CGSize(width: 50, height: 50)
        backButton.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        backButton.layer.cornerRadius = 25
        view.addSubview(backButton)
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
        
        detailForm.setContentOffset(.zero, animated: true)
        detailForm.showsVerticalScrollIndicator = false
        backButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var leftTop: CGPoint
        
        // TODO: present 된 상태를 이렇게 말고 더 확실하게 식별할 수 있는 방법이 있을까?
        if view.frame.width < UIScreen.main.bounds.width {
            leftTop = .zero
        } else {
            leftTop = CGPoint(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top)
        }
        
        backButton.frame.origin = CGPoint(x: leftTop.x + 20, y: leftTop.y + 20)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
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
