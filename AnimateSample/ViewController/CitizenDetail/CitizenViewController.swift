//
//  CitizenViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 목록을 표시하는 홈
class CitizenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        title = "모여봐요 동물의 숲"
     
        let customCollectionLayout = ScaleableCollectionLayout()
        customCollectionLayout.itemSize = CGSize(width: 100, height: 400)
        customCollectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let citizenMimimumCollection = CitizenCollectionView(frame: view.frame, collectionViewLayout: customCollectionLayout)
        if #available(iOS 13.0, *) {
            citizenMimimumCollection.backgroundColor = .systemBackground
        } else {
            citizenMimimumCollection.backgroundColor = .white
        }
        citizenMimimumCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(citizenMimimumCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("home view will appear")
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
