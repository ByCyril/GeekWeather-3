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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        dayLabel.font = GWFont.AvenirNext(style: .Medium, size: 21)
        highTempLabel.font = GWFont.AvenirNext(style: .Bold, size: 25)
        lowTempLabel.font = GWFont.AvenirNext(style: .Medium, size: 20)

        dayLabel.textColor = .white
        highTempLabel.textColor = .white
        lowTempLabel.textColor = .white
        
        [dayLabel, highTempLabel, lowTempLabel, iconView].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            addSubview(element)
        }
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding + 5),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.widthAnchor.constraint(equalToConstant: 45),
            
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            
            highTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            highTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            highTempLabel.trailingAnchor.constraint(equalTo: lowTempLabel.leadingAnchor, constant: -padding / 2),
            
            lowTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            lowTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            lowTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: (-padding * 2) - 5)
        ])
        
        layoutIfNeeded()
        
        setupAccessibilityElements()
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
