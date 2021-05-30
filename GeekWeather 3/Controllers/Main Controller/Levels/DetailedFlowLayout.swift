//
//  DetailedFlowLayout.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

protocol DetailedFlowLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class DetailedFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: DetailedFlowLayoutDelegate?
    
    let numberOfColumns = 2
    let cellPadding: CGFloat = 6
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let colWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for col in 0..<numberOfColumns {
            xOffset.append(CGFloat(col) * colWidth)
        }
                
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let itemHeight: CGFloat = 65
            let height = cellPadding * 2 + itemHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: colWidth,
                               height: height)

            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
