//
//  GridCollectionViewLayout.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class GridCollectionViewLayout: UICollectionViewFlowLayout {
    var originalIndexPath: IndexPath?
    var draggingIndexPath: IndexPath?
    
    var draggingView: UIView?
    
    var dragOffset: CGPoint = .zero
    
    func applyDraggingAttributes(attributes: UICollectionViewLayoutAttributes) {
        attributes.alpha = 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let visibleAttributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1
        
        visibleAttributes.forEach { attributes in
            // 새로운 줄
            if attributes.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            attributes.frame.origin.x = leftMargin
            
            leftMargin += attributes.frame.width + minimumInteritemSpacing + minimumInteritemSpacing
            maxY = max(attributes.frame.maxY , maxY)
            
            // 드래그 중인 cell 투명하게
            if attributes.indexPath == draggingIndexPath,
               attributes.representedElementCategory == .cell {
                self.applyDraggingAttributes(attributes: attributes)
            }
        }

        return visibleAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        if indexPath == draggingIndexPath,
           attributes.representedElementCategory == .cell {
            applyDraggingAttributes(attributes: attributes)
        }

        return attributes
    }
    
    func handleDragInput(_ state: UILongPressGestureRecognizer.State, location: CGPoint) {
        switch state {
        case .began:
            startDragAtLocation(location: location)
            
        case .changed:
            updateDragAtLocation(location: location)
            
        case .ended:
            endDragAtLocation(location: location)
            
        default:
            break
        }
    }
    
    func startDragAtLocation(location: CGPoint) {
        guard let cv = collectionView,
              let indexPath = cv.indexPathForItem(at: location),
              let cell = cv.cellForItem(at: indexPath),
              let copiedView = cell.snapshotView(afterScreenUpdates: false) else {
            return
        }
        
        originalIndexPath = indexPath
        draggingIndexPath = indexPath
        
        
        copiedView.center = cell.center
//        copiedView.frame = cell.frame.applying(CGAffineTransform(scaleX: 1.2, y: 1.2))
        copiedView.backgroundColor = cell.backgroundColor
        cv.addSubview(copiedView)
        
        dragOffset = CGPoint(x: cell.center.x - location.x, y: cell.center.y - location.y)
        
        copiedView.layer.shadowOpacity = cell.layer.shadowOpacity
        copiedView.layer.shadowRadius = cell.layer.shadowRadius
        copiedView.layer.cornerRadius = cell.layer.cornerRadius
        
        self.draggingView = copiedView
        
        invalidateLayout()
        
        // don't use animation
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.draggingView?.alpha = 0.95
            self.draggingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    func updateDragAtLocation(location: CGPoint) {
        guard let draggingView = draggingView,
              let cv = collectionView,
              let dataSource = cv.dataSource as? GridUXViewController else {
            return
        }
        
        draggingView.center = CGPoint(x: location.x + dragOffset.x, y: location.y + dragOffset.y)

        if let targetIndexPath = cv.indexPathForItem(at: location) {
            cv.performBatchUpdates({
                cv.moveItem(at: draggingIndexPath!, to: targetIndexPath)
                dataSource.moveInfo(self.draggingIndexPath!, to: targetIndexPath)
                
                draggingIndexPath = targetIndexPath
            }, completion: nil)
        }
    }
    
    func endDragAtLocation(location: CGPoint) {
        guard let draggingView = draggingView,
              let draggingIndexPath = draggingIndexPath,
              let originalIndexPath = originalIndexPath,
              let cv = collectionView,
              let dataSource = cv.dataSource else {
            return
        }
        
        let targetCenter = dataSource.collectionView(cv, cellForItemAt: draggingIndexPath).center
        
        UIView.animate(withDuration: 0.4, animations: {
            draggingView.center = targetCenter
            draggingView.transform = CGAffineTransform.identity
        }, completion: { completed in
            if draggingIndexPath != originalIndexPath {
                dataSource.collectionView?(cv, moveItemAt: originalIndexPath, to: draggingIndexPath)
            }
            
            draggingView.removeFromSuperview()
            self.draggingIndexPath = nil
            self.draggingView = nil
            self.invalidateLayout()
        })
    }
}
