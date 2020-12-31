//
//  NavigationView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class NavigationView: UIView {
    
    @IBOutlet var rollableTitleView: RollableTitleView!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsButton.applyAccessibility(with: "Settings", and: nil, trait: .button)
        searchButton.applyAccessibility(with: "Search", and: nil, trait: .button)
    }
}
