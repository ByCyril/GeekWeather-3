//
//  LebelTwoViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelTwoViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func initUI() {
        
    }
    
    override func update(from notification: NSNotification) {
        
    }
}
