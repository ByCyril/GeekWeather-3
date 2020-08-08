//
//  CollectionViewDelegateManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/4/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class CollectionViewDelegateManager: CollectionViewManager, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let view = views[indexPath.row]
        view.animate()
    }
}
