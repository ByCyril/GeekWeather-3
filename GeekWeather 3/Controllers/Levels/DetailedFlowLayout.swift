//
//  DetailedFlowLayout.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

protocol DetailedFlowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, widthForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class DetailedFlowLayout: UICollectionViewLayout {
    
    weak var delegate: DetailedFlowLayoutDelegate?
    
    let numberOfRows = 2
    let cellPadding: CGFloat = 6
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    var contentWidth: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // 1
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let rowHeight = contentHeight / CGFloat(numberOfRows)
        var yOffset: [CGFloat] = []
        
        for row in 0..<numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
                
        var row = 0
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfRows)
        
        // 3
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let itemWidth = delegate?.collectionView(collectionView, widthForItemAtIndexPath: indexPath) ?? 180
            let width = cellPadding * 2 + itemWidth
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[row],
                               width: width,
                               height: rowHeight)

            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < (numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
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
