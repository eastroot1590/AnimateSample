//
//  DynamicCollectionLayout.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class DynamicCollectionLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1
        var verticalCenter: CGFloat = -1
        
        var sameLine: [UICollectionViewLayoutAttributes] = []
        attributes.forEach { layoutAttribute in
            // 새로운 줄
            if layoutAttribute.frame.origin.y >= maxY {
                var minY: CGFloat = .infinity
                // 같은 줄 중에 가장 윗변 높이
                sameLine.forEach { attribute in
                    minY = min(attribute.frame.minY, minY)
                }
                
                // 같은 줄 위쪽으으로 정렬
                sameLine.forEach { attribute in
                    attribute.frame.origin.y = minY
                }
                sameLine.removeAll()
                
                leftMargin = sectionInset.left
                verticalCenter = layoutAttribute.center.y
            }
            
            // 같은 줄 찾기
            if abs(layoutAttribute.center.y - verticalCenter) < 1 {
                sameLine.append(layoutAttribute)
                verticalCenter = layoutAttribute.center.y
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
    
    func topAlignment(_ attributes: [UICollectionViewLayoutAttributes]) {
    }
}
