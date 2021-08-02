//
//  ViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 목록을 표시하는 홈
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "모여봐요 동물의 숲"
     
        let customCollectionLayout = ScaleableCollectionLayout()
        customCollectionLayout.itemSize = CGSize(width: 100, height: 400)
        customCollectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let citizemMimimumCollection = CitizenCollectionView(frame: view.frame, collectionViewLayout: customCollectionLayout)
        citizemMimimumCollection.backgroundColor = .systemBackground
        citizemMimimumCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(citizemMimimumCollection)
    }
}
