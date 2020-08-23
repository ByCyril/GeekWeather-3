//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelThreeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func initUI() {
        
    }
    
    override func update(from notification: NSNotification) {
        
    }
}

