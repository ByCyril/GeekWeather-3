//
//  LevelTwoHourlyViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelTwoHourlyViewCell: UICollectionViewCell {
    
    var timestampLabel = UILabel()
    var tempLabel = UILabel()
    var iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setupAccessibilityElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        timestampLabel.font = GWFont.AvenirNext(style: .Medium, size: 17)
        timestampLabel.textAlignment = .center
        timestampLabel.textColor = .white
        
        tempLabel.font = GWFont.AvenirNext(style: .Bold, size: 18)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        
        [timestampLabel, tempLabel, iconView].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            addSubview(element)
        }
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: topAnchor),
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timestampLabel.heightAnchor.constraint(equalToConstant: 20),
            
            iconView.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: padding),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            iconView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -padding),
            
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tempLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        layoutIfNeeded()
    }
    
    func setupAccessibilityElements() {
        timestampLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: timestampLabel.font)
        tempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: tempLabel.font)
        
        [tempLabel, timestampLabel].forEach { (element) in
            element.isAccessibilityElement = false
            element.adjustsFontForContentSizeCategory = true
            element.sizeToFit()
            element.numberOfLines = 1
        }
        
        isAccessibilityElement = true
    }
    
}
