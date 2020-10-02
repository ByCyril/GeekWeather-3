//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class ElementFactory {
    
    func titleFont() -> UIFont {
        guard let customFont = UIFont(name: "Futura", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        return customFont
    }
    func createCellTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: titleFont())
        return label
    }
    
    func createCellSubtitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: titleFont())
        return label
    }
}

final class LevelThreeCell: UICollectionViewCell {
    
    private let elementFactory = ElementFactory()
    
    func createGenericCellType(titleText: String, subtitleText: String) {
        
        let titleLabel = elementFactory.createCellTitle()
        let subtitleLabel = elementFactory.createCellSubtitle()
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            
        ])
        
        
    }
    
    func createTwoSectionCellType(titleOneText: String?,
                                  subtitleOneText: String?,
                                  titleTwoText: String?,
                                  subtitleTwoText: String?) {
        
    }
    
}

protocol LevelThreeCellItem {
    var cellSize: CGSize { get }
    func createCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

final class SunsetSunriseCellItem: LevelThreeCellItem {
    var cellSize: CGSize = CGSize(width: 128, height: 128)
    
    func createCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LevelThreeCell else { return UICollectionViewCell() }
        
        return cell
    }
}

final class LevelThreeViewController: BaseView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = Bundle.main.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        
        loadXib(view, self)
        collectionView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
}
