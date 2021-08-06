//
//  CitizenCollectionView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 목록을 표시하는 CollectionView
class CitizenCollectionView: UICollectionView {
    var citizenInfos: [CitizenInfo] = []
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        
        // load data
        guard let citizenData = NSDataAsset(name: "CitizenList") else {
            print("Couldn't load CitizenList")
            return
        }
        
        do {
            self.citizenInfos = try JSONDecoder().decode([CitizenInfo].self, from: citizenData.data)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        delegate = self
        dataSource = self
        
        register(CitizenMinimumCell.self, forCellWithReuseIdentifier: "CitizenMimimum")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CitizenCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citizenInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitizenMimimum", for: indexPath)
        
        if let citizenCell = cell as? CitizenMinimumCell,
           indexPath.item < citizenInfos.count {
            citizenCell.initialize(data: citizenInfos[indexPath.item])
            
            return citizenCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < citizenInfos.count,
              let selectedCell = collectionView.cellForItem(at: indexPath) as? CitizenMinimumCell,
              let homeNavigation = rootNavigationController as? HomeNavigationController else {
            return
        }
        
        // DetailViewController
        let citizenDetailViewController = CitizenDetailViewController(citizenInfo: citizenInfos[indexPath.item])
        let originFrame = selectedCell.convert(selectedCell.primeView.frame, to: homeNavigation.view)
        citizenDetailViewController.pushAnimator = ExpandPushAnimator(selectedCell: selectedCell, originFrame: originFrame)
        citizenDetailViewController.popAnimator = ExpandPopAnimator(selectedCell: selectedCell, originFrame: originFrame)
        
        // push
        homeNavigation.pushInteractivePopableViewController(citizenDetailViewController, animated: true)
    }
}
