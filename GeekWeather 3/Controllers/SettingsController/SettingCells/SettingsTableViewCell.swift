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
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: GWFont.AvenirNext(style: .Medium, size: 17))
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: GWFont.AvenirNext(style: .Medium, size: 17))
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
        
        let padding: CGFloat = 12
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        NSLayoutConstraint.activate([

            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            
            detailLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            detailLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

        ])
        
        layoutIfNeeded()
    }
}
