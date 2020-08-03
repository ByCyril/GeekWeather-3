//
//  AccessibilityFactory.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/2/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class AccessibilityFactory {
   
    func applyAccessibility(to view: UIView, with label: String, trait: UIAccessibilityTraits) {
        view.isAccessibilityElement = true
        view.accessibilityLabel = label
        view.accessibilityTraits = trait
    }
    
    /* populate with your own custom methods that fit your needs! */
}
