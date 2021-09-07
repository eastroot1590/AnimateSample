//
//  ScaleableCollectionLayout.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/02.
//

import UIKit

class ScaleableCollectionLayout: UICollectionViewFlowLayout {
    /// 각 cell이 본모습으로 표현되는 최대 거리. 이 거리보다 더 멀리있는 cell은 layout을 다시 계산한다.
    var accessibleDistance: CGPoint  = CGPoint(x: 0, y: 600)
    
    var intensity: CGFloat = 0.3
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    
    override init() {
        super.init()
        
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepare() {
//        guard let collectionView = collectionView else {
//            return
//        }
//        
//        itemSize = CGSize(width: collectionView.frame.width - sectionInset.left - sectionInset.right, height: itemSize.height)
//        
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//            
//            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            let frame = CGRect(origin: CGPoint(x: sectionInset.left, y: sectionInset.top + CGFloat(item) * (itemSize.height + minimumLineSpacing)),
//                               size: itemSize)
//            attribute.frame = frame
//            
//            attributes.append(attribute)
//        }
//    }
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let collectionView = collectionView else {
//            return nil
//        }
//        
//        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
//        var visibleAttributes: [UICollectionViewLayoutAttributes] = []
//        
//        for attribute in attributes {
//            if visibleRect.intersects(attribute.frame) {
//                let absoluteYDistance = (attribute.frame.minY - visibleRect.minY).magnitude
//                let distance = max(accessibleDistance.y, absoluteYDistance) - accessibleDistance.y
//                let offset = distance / (visibleRect.height - accessibleDistance.y) * intensity
//                let scale: CGFloat = 1 - offset
//                
//                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
//                attribute.zIndex = collectionView.numberOfItems(inSection: 0) - attribute.indexPath.item
//                attribute.alpha = scale
//                
//                visibleAttributes.append(attribute)
//            }
//        }
//        
//        return visibleAttributes
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
