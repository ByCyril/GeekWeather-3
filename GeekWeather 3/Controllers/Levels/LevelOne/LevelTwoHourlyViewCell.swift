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
        
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        timestampLabel.font = GWFont.AvenirNext(style: .Medium, size: 21)
        timestampLabel.textAlignment = .center
        timestampLabel.textColor = .white
        
        tempLabel.font = GWFont.AvenirNext(style: .Bold, size: 25)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        
        [timestampLabel, tempLabel, iconView].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            addSubview(element)
        }
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timestampLabel.heightAnchor.constraint(equalToConstant: 35),
            
            iconView.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor),
            
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tempLabel.heightAnchor.constraint(equalToConstant: 40)
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
