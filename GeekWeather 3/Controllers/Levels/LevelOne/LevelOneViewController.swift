//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelOneViewController: UIViewController {
   
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: locationLabel.font)
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: commentLabel.font)
        
        locationLabel.adjustsFontForContentSizeCategory = true
        tempLabel.adjustsFontForContentSizeCategory = true
        summaryLabel.adjustsFontForContentSizeCategory = true
        commentLabel.adjustsFontForContentSizeCategory = true
    }
    
}
