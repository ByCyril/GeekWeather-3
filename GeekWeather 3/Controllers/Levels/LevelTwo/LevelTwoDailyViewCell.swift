//
//  LevelTwoDailyViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelTwoDailyViewCell: UICollectionViewCell {
    var dayLabel = UILabel()
    var highTempLabel = UILabel()
    var lowTempLabel = UILabel()
    var iconView = UIImageView()
    var percLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [dayLabel, highTempLabel, lowTempLabel, iconView, percLabel].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            addSubview(element)
        }
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
    }
    
    func setupAccessibilityElements() {
        dayLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: dayLabel.font)
        
        highTempLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: highTempLabel.font)
        lowTempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: lowTempLabel.font)
        
        [dayLabel, highTempLabel, lowTempLabel].forEach { (element) in
            element.isAccessibilityElement = false
            element.adjustsFontForContentSizeCategory = true
            element.sizeToFit()
            element.numberOfLines = 0
        }
        
        isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
