//
//  CollectionViewDataSourceManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/4/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class CollectionViewDataSourceManager: CollectionViewManager, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainControllerViewCell else { return MainControllerViewCell() }
                
        cell.initUI(views[indexPath.row])
        
        return cell
    }
}
