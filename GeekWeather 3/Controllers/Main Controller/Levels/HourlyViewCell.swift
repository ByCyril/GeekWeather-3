//
//  HourlyViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class HourlyViewCell: UICollectionViewCell {
    
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
        
        timestampLabel.font = GWFont.AvenirNext(style: .Medium, size: 19)
        timestampLabel.adjustsFontSizeToFitWidth = true
        timestampLabel.textAlignment = .center
        timestampLabel.textColor = .white
        timestampLabel.minimumScaleFactor = 0.2
        
        tempLabel.font = GWFont.AvenirNext(style: .Bold, size: 19)
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
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            timestampLabel.heightAnchor.constraint(equalToConstant: 20),
            
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 5),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            iconView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -2.5),
            
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            tempLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        layoutIfNeeded()
    }
    
    func setupAccessibilityElements() {
        
        [tempLabel, timestampLabel].forEach { (element) in
            element.isAccessibilityElement = false
            element.sizeToFit()
            element.numberOfLines = 1
        }
        
        isAccessibilityElement = true
    }
    
}
