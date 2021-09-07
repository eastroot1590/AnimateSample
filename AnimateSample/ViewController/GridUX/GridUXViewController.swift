//
//  GridUXViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class GridUXViewController: UIViewController {
    var collectionView: UICollectionView!
    
    let completeButton = UIButton()
    
    var cellInfo: [DragCellInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = GridCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        collectionView.register(GridUXCell.self, forCellWithReuseIdentifier: "CellTypeA")
        collectionView.backgroundColor = .gray
        collectionView.dragInteractionEnabled = false
        collectionView.contentMode = .left
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
        
        for _ in 0 ..< 50 {
            let color = UIColor(red: 0.5 + CGFloat.random(in: 0 ... 0.5), green: 0.5 + CGFloat.random(in: 0 ... 0.5), blue: 0.5 + CGFloat.random(in: 0 ... 0.5), alpha: 1)
            cellInfo.append(DragCellInfo(color: color, size: .small))
        }
        
        cellInfo.insert(DragCellInfo(color: .systemRed, size: .medium), at: 4)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: .medium), at: 13)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: .medium), at: 17)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: .medium), at: 29)
        cellInfo.insert(DragCellInfo(color: .systemRed, size: .medium), at: 41)
        
        cellInfo.insert(DragCellInfo(color: .systemGreen, size: .large), at: 5)
        cellInfo.insert(DragCellInfo(color: .systemGreen, size: .large), at: 16)
        cellInfo.insert(DragCellInfo(color: .systemGreen, size: .large), at: 21)
        cellInfo.insert(DragCellInfo(color: .systemGreen, size: .large), at: 6)
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTouch))
        recognizer.minimumPressDuration = 0.3
        view.addGestureRecognizer(recognizer)
        
        // foreground
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackround), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func appEnterBackround() {
        print("app enter background")
        
        collectionView.visibleCells.forEach { cell in
            guard let dragCell = cell as? GridUXCell else {
                return
            }
            
            dragCell.stop()
        }
        
        completeButton.isHidden = true
        collectionView.dragInteractionEnabled = false
    }
    
    @objc func handleTouch(longPress: UILongPressGestureRecognizer) {
        guard !collectionView.dragInteractionEnabled else {
            if let dynamicLayout = collectionView.collectionViewLayout as? GridCollectionViewLayout {
                dynamicLayout.handleDragInput(longPress.state, location: longPress.location(in: collectionView))
            }
            return
        }
        
        print("edit begin")
        
        var i: Int = 0
        collectionView.visibleCells.forEach { cell in
            guard let dragCell = cell as? GridUXCell else {
                return
            }
            dragCell.shake(i % 2 == 0 ? -1 : 1)
            i += 1
        }
        
        collectionView.dragInteractionEnabled = true
        completeButton.isHidden = false
    }
    
    @objc func cancel() {
        print("edit end")
        
        collectionView.visibleCells.forEach { cell in
            guard let dragCell = cell as? GridUXCell else {
                return
            }
            
            dragCell.stop()
        }
        
        completeButton.isHidden = true
        collectionView.dragInteractionEnabled = false
    }
    
    func minColumn(_ what: CGFloat) -> CGFloat {
        return 3
    }
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension GridUXViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellTypeA", for: indexPath) as! GridUXCell
        
        cell.backgroundColor = cellInfo[indexPath.item].color
        if collectionView.dragInteractionEnabled {
            cell.shake(indexPath.item % 2 == 0 ? -1 : 1)
        } else {
            cell.stop()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dragCell = cell as? GridUXCell else {
            return
        }
        
        if collectionView.dragInteractionEnabled {
            dragCell.shake(indexPath.item % 2 == 0 ? -1 : 1)
        } else {
            dragCell.stop()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGSize = .zero
        let edge = (collectionView.frame.width - 40) / 3
        
        switch cellInfo[indexPath.item].size {
        case .small:
            cellSize = CGSize(width: edge, height: edge)
            
        case .medium:
            cellSize = CGSize(width: edge * 2 + 10, height: edge)
            
        case .large:
            cellSize = CGSize(width: edge * 3 + 20, height: edge)
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func moveInfo(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.item != destinationIndexPath.item else {
            return
        }

        let temp = cellInfo.remove(at: sourceIndexPath.item)
        cellInfo.insert(temp, at: destinationIndexPath.item)
    }
    
    func cellSizeType(_ indexPath: IndexPath) -> DragCellInfo.CellSize {
        return cellInfo[indexPath.item].size
    }
}
