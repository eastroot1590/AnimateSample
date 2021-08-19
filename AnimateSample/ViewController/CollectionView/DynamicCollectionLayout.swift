//
//  DynamicCollectionLayout.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/19.
//

import UIKit

class DynamicCollectionLayout: UICollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height: contentHeight)
        }
    }
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    var contentWidth: CGFloat {
        set {
            columnWidth = newValue / CGFloat(self.columnCount)
        } get {
            return self.columnWidth * CGFloat(self.columnCount)
        }
    }
    var contentHeight: CGFloat = 0
    var columnWidth: CGFloat = 0
    var columnCount: Int = 3
    var cellInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var originY: [CGFloat] = []

    override func prepare() {
        super.prepare()
        
        guard let controller = collectionView?.dataSource as? CollectionDragViewController,
              let collectionView = collectionView else {
            return
        }
        
        // offset
        originY = Array<CGFloat>.init(repeating: 0, count: columnCount)
        contentHeight = 0
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 이게 pinterest 할려고 이렇게 한거였는데 이번에는 다르니까 새로운 방법으로 계산해야 한다.
                let column = minColumn(originY)
                
                let x = CGFloat(column) * columnWidth + cellInset.left
                let y = originY[column] + cellInset.top
//                let width = columnWidth - cellInset.left - cellInset.right
                let size = controller.collectionView(collectionView, layout: self, sizeForItemAt: IndexPath(item: item, section: section))
                
                attributes.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
                originY[column] += size.height + cellInset.bottom
                
                if contentHeight < originY[column] {
                    contentHeight = originY[column]
                }
                
                layoutAttributes.append(attributes)
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in layoutAttributes {
            print(attributes.frame)
            if rect.intersects(attributes.frame) {
                visibleAttributes.append(attributes)
                
            }
            
        }
        return visibleAttributes

//        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
//            return nil
//        }
//
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1
//        var verticalCenter: CGFloat = -1
//
//        var sameLine: [UICollectionViewLayoutAttributes] = []
//        attributes.forEach { layoutAttribute in
//            // 새로운 줄
//            if layoutAttribute.frame.origin.y >= maxY {
//                var minY: CGFloat = .infinity
//                // 같은 줄 중에 가장 윗변 높이
//                sameLine.forEach { attribute in
//                    minY = min(attribute.frame.minY, minY)
//                }
//
//                // 같은 줄 위쪽으으로 정렬
//                sameLine.forEach { attribute in
//                    attribute.frame.origin.y = minY
//                }
//                sameLine.removeAll()
//
//                leftMargin = sectionInset.left
//                verticalCenter = layoutAttribute.center.y
//            }
//
//            // 같은 줄 찾기
//            if abs(layoutAttribute.center.y - verticalCenter) < 1 {
//                sameLine.append(layoutAttribute)
//                verticalCenter = layoutAttribute.center.y
//            }
//
//            layoutAttribute.frame.origin.x = leftMargin
//
//            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing + minimumInteritemSpacing
//            maxY = max(layoutAttribute.frame.maxY , maxY)
//        }
//
//        return attributes
    }
    
    func minColumn(_ columns: [CGFloat]) -> Int {
        var index: Int = 0
        var minValue: CGFloat = .infinity
        
        for i in 0 ..< columns.count {
            if minValue < columns[i] {
                minValue = columns[i]
                index = i
            }
        }
        
        return index
    }
}
