//
//  DetailedFlowLayout.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

protocol DetailedFlowLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class DetailedFlowLayout: UICollectionViewLayout {
    weak var delegate: DetailedFlowLayoutDelegate?
    
    let numberOfRows = 2
}
