//
//  TestViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "테스트"
        
        view.backgroundColor = .systemBackground
        
        let layout = ScaleableCollectionLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 40) / 2, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
}

extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        
        return cell
    }
}
