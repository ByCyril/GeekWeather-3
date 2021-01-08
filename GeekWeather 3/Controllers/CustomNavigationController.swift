//
//  CustomNavigationController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/7/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Bold, size: 35)]
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = attributes
    }
 
}
