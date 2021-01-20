//
//  DetailedViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class DetailedViewCell: UICollectionViewCell {
    var firstItemLabel = UILabel()
    var firstItemValue = UILabel()
    let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        let label = GWFont.AvenirNext(style: .Regular, size: 15)
        let value = GWFont.AvenirNext(style: .Medium, size: 25)
        
        firstItemLabel.numberOfLines = 0
        firstItemValue.numberOfLines = 0
        firstItemLabel.adjustsFontForContentSizeCategory = true
        firstItemValue.adjustsFontForContentSizeCategory = true
        firstItemLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: label, maximumPointSize: 25)
        firstItemValue.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: value, maximumPointSize: 35)
        
        firstItemLabel.translatesAutoresizingMaskIntoConstraints = false
        firstItemValue.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        contentView.layer.cornerRadius = 20
    
        contentView.addSubview(firstItemLabel)
        contentView.addSubview(firstItemValue)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            firstItemLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            firstItemLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            firstItemLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            firstItemValue.topAnchor.constraint(equalTo: firstItemLabel.bottomAnchor),
            firstItemValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            firstItemValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            firstItemValue.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        layoutIfNeeded()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
