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
        collectionView.register(TestExpandableCell.self, forCellWithReuseIdentifier: "default")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("test view will appear navigation bar show")
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! TestExpandableCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? TestExpandableCell,
              let homeNavigation = collectionView.rootNavigationController as? HomeNavigationController else {
            return
        }

        let testDetailViewController = TestDetailViewController()
        let originFrame = selectedCell.convert(selectedCell.primeView.frame, to: homeNavigation.view)
        testDetailViewController.pushAnimator = ExpandPushAnimator(selectedCell: selectedCell, originFrame: originFrame)
        testDetailViewController.popAnimator = ExpandPopAnimator(selectedCell: selectedCell, originFrame: originFrame)

        homeNavigation.pushCustomTransitioningViewController(testDetailViewController, animated: true)
    }
}
