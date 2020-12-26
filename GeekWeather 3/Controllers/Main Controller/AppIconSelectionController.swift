//
//  AppIconSelectionController.swift
//  GeekWeather 2
//
//  Created by Cyril Garcia on 1/12/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import UIKit

final class AppIconSelectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}

final class AppIconSelectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.setAlternateIconName("AppIcon-\(indexPath.row)") { error in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AppIconSelectionCell else { return AppIconSelectionCell() }
        cell.imageView.image = UIImage(named: "AppIcon\(indexPath.row)")
        cell.imageView.layer.cornerRadius = 20
        return cell
    }
}
