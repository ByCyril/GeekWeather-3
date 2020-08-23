//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelOneViewController: BaseViewController {
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .white
        label.text = "81°"
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.text = "San Jose, CA"
        label.backgroundColor = .red
        
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func initUI() {
        view.addSubview(tempLabel)
        view.addSubview(locationLabel)
        
        
        NSLayoutConstraint.activate([
            
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            tempLabel.heightAnchor.constraint(equalToConstant: 75),

            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 50),
            locationLabel.lastBaselineAnchor.constraint(equalTo: tempLabel.firstBaselineAnchor),
            
        ])
        
        view.layoutIfNeeded()
        
        gradientLayer.colors = [UIColor.init(rgb: 0xF4B100).cgColor,
                                UIColor.init(rgb: 0xFD6B00).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func update(from notification: NSNotification) {
        
    }
}

