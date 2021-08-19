//
//  CollectionDragViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class CollectionDragViewController: UIViewController {
    var collectionView: UICollectionView!
    
    let completeButton = UIButton()
    
    var cellInfo: [DragCellInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        collectionView.register(DragCell.self, forCellWithReuseIdentifier: "CellTypeA")
        collectionView.dragInteractionEnabled = false
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin]
        view.addSubview(collectionView)
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.backgroundColor = .systemBlue
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(completeButton)
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        completeButton.isHidden = true
        
        let edge: CGFloat = (view.frame.width - 40) / 3
        
        for _ in 0 ..< 50 {
            cellInfo.append(DragCellInfo(color: .systemBlue, size: CGSize(width: edge, height: edge)))
        }
        
        cellInfo.insert(DragCellInfo(color: .systemRed, size: CGSize(width: edge * 2 + 10, height: edge)), at: 5)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: CGSize(width: edge * 2 + 10, height: edge)), at: 12)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: CGSize(width: edge * 2 + 10, height: edge)), at: 29)
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleTouch)))
    }
    
    @objc func handleTouch() {
        print(collectionView.dragInteractionEnabled)
        guard !collectionView.dragInteractionEnabled else {
            return
        }
        
        print("edit begin")
        
        var i: Int = 0
        collectionView.visibleCells.forEach { cell in
            guard let dragCell = cell as? DragCell else {
                return
            }
            dragCell.shake(i % 2 == 0 ? -1 : 1)
            i += 1
        }
        
        collectionView.dragInteractionEnabled = true
        completeButton.isHidden = false
    }
    
    @objc func cancel() {
        collectionView.visibleCells.forEach { cell in
            guard let dragCell = cell as? DragCell else {
                return
            }
            
            dragCell.stop()
        }
        
        completeButton.isHidden = true
        collectionView.dragInteractionEnabled = false
    }
}

extension CollectionDragViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellTypeA", for: indexPath) as! DragCell
        
        cell.backgroundColor = cellInfo[indexPath.item].color
        if collectionView.dragInteractionEnabled {
            cell.shake(indexPath.item % 2 == 0 ? -1 : 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellInfo[indexPath.item].size
    }
}

extension CollectionDragViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    // drag
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        print("allow")
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        print("drag session begin")
        completeButton.isHidden = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        print("drag session did end")
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 컨텐츠를 넣어야 됨
        let provider = NSItemProvider(object: cellInfo[indexPath.item].color)
        
        let dragItem = UIDragItem(itemProvider: provider)
        
        return [dragItem]
    }
    
    // drop
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print("drop session did end")
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {
                return
            }
            
            collectionView.performBatchUpdates({
                let temp = cellInfo.remove(at: sourceIndexPath.item)
                cellInfo.insert(temp, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: { completed in
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            })
        }
    }
    
//    func playShake(_ collectionView: UICollectionView) {
//        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
//            guard let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) else {
//                return
//            }
//
//            let odd: CGFloat = item % 2 == 0 ? 1 : -1
//            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
//            animation.calculationMode = .linear
//            animation.values = [
//                CGFloat(0).radian,
//                CGFloat(-5).radian * odd,
//                CGFloat(5).radian * odd,
//                CGFloat(0).radian
//            ]
//            animation.keyTimes = [
//                0,
//                0.25,
//                0.75,
//                1
//            ]
//            animation.repeatCount = .infinity
//            animation.duration = 0.5
//            cell.layer.add(animation, forKey: "transform")
//        }
//    }
}
