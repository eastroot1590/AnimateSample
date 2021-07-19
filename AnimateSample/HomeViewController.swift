//
//  ViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

class HomeViewController: UIViewController {
    var citizenMinimumList: [CitizenMinimumData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "모여봐요 동물의 숲"
        
        // load data
        guard let citizenData = NSDataAsset(name: "CitizenList") else {
            print("Couldn't load CitizenList")
            return
        }
        
        do {
            self.citizenMinimumList = try JSONDecoder().decode([CitizenMinimumData].self, from: citizenData.data)
        } catch {
            print(error.localizedDescription)
        }
     
        let customCollectionLayout = UICollectionViewFlowLayout()
        customCollectionLayout.itemSize = CGSize(width: 100, height: 150)
        customCollectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let citizemMimimumCollection = UICollectionView(frame: view.frame, collectionViewLayout: customCollectionLayout)
        citizemMimimumCollection.backgroundColor = .systemBackground
        citizemMimimumCollection.autoresizingMask = [.flexibleTopMargin]
        citizemMimimumCollection.register(CitizenMinimumCell.self, forCellWithReuseIdentifier: "CitizenMimimum")
        citizemMimimumCollection.delegate = self
        citizemMimimumCollection.dataSource = self
        view.addSubview(citizemMimimumCollection)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
}
