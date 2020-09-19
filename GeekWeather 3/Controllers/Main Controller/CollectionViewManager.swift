//
//  CollectionViewManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/17/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class CollectionViewManager: NSObject {
    var views = [BaseViewController]()
    
    init(_ views: [BaseViewController]) {
        super.init()
        self.views = views
    }
}

final class CollectionViewDelegateManager: CollectionViewManager, UICollectionViewDelegate {
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
                
        let view = views[indexPath.row]
        
        if indexPath.row > 0 {
            view.viewDidLoad()
        }
        
        view.view.layoutSubviews()
        cell.initUI(view.view)
        
        return cell
    }
}
