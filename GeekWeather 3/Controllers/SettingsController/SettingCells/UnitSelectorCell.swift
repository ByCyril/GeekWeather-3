//
//  UnitSelectorCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class UnitSelectorCell: SettingsTableViewCell {
    
    var unitSegmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["One", "Two", "Three"])
        return segmentController
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    override func initUI() {
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
