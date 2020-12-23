//
//  AccessibilityFactory.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/2/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

extension UIView {
    func applyAccessibility(with label: String, and value: String?, trait: UIAccessibilityTraits) {
        isAccessibilityElement = true
        accessibilityLabel = label
        accessibilityTraits = trait

        if let value = value {            
            accessibilityValue = value
        }
    }
    
    func notAccessibilityElement() {
        isAccessibilityElement = false
    }
}
