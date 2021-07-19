//
//  CitizenCollectionView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 목록을 표시하는 CollectionView
class CitizenCollectionView: UICollectionView {
    var citizenMinimumList: [CitizenMinimumData] = []
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        
        // load data
        guard let citizenData = NSDataAsset(name: "CitizenList") else {
            print("Couldn't load CitizenList")
            return
        }
        
        do {
            self.citizenMinimumList = try JSONDecoder().decode([CitizenMinimumData].self, from: citizenData.data)
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
        return citizenMinimumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitizenMimimum", for: indexPath)
        
        if let citizenCell = cell as? CitizenMinimumCell,
           indexPath.item < citizenMinimumList.count {
            citizenCell.initialize(data: citizenMinimumList[indexPath.item])
            
            return citizenCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < citizenMinimumList.count,
              let selectedCell = collectionView.cellForItem(at: indexPath) as? CitizenMinimumCell,
              let homeNavigation = rootNavigationController as? HomeNavigationController else {
            return
        }
        
        // Animator
        let transitioningPushAnimator = ExpandPushAnimator(selectedCell: selectedCell)
        let transitioningPopAnimator = ExpandPopAnimator(selectedCell: selectedCell)
        
        // DetailViewController
        let citizenDetailViewController = CitizenDetailViewController(citizen: citizenMinimumList[indexPath.item])
        citizenDetailViewController.transitioningPushAnimator = transitioningPushAnimator
        citizenDetailViewController.transitioningPopAnimator = transitioningPopAnimator
        
        // push
        // TODO: pushViewController만 호출하는 것으로 수정
        homeNavigation.transitioningViewController = citizenDetailViewController
        homeNavigation.pushViewController(citizenDetailViewController, animated: true)
    }
}
