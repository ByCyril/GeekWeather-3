//
//  CollectionViewManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/17/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class CollectionViewManager: NSObject {
    var views = [BaseView]()
    var cellSize: CGSize?
    
    init(_ views: [BaseView]) {
        super.init()
        self.views = views
    }
    
    init(_ views: [BaseView], _ cellSize: CGSize) {
        super.init()
        self.views = views
        self.cellSize = cellSize
    }
    
}

final class CollectionViewDelegateManager: CollectionViewManager, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        views.first?.getContentOffset(scrollView.contentOffset)
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let view = views[indexPath.row]
        
        view.animate()
    }
}


final class CollectionViewDataSourceManager: CollectionViewManager, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainViewCell else { return MainViewCell() }
        cell.initUI(views[indexPath.row])
        return cell
    }
}
