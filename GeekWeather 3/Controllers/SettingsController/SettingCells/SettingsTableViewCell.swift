//
//  SettingsTableViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: label.font)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: label.font)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        let padding: CGFloat = 10
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
//            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 45),
            iconImageView.widthAnchor.constraint(equalToConstant: 45),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
//            titleLabel.heightAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding * 2.5),
//            detailLabel.heightAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
        
        layoutIfNeeded()
    }
}
