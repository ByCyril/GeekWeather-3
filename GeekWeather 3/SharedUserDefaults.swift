//
//  SharedUserDefaults.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/1/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation

let sharedUserDefaults = UserDefaults(suiteName: SharedUserDefaults.suiteName)

struct SharedUserDefaults {
    static let suiteName = "group.com.ByCyril.GeekWeather-2"
    
    struct Keys {
        static let is24Hour = "is24Hour"
        static let Units = "Units"
        static let Temperature = "Temperature"
        static let ExistingUser = "ExistingUser"
        static let LastUpdated = "LastUpdated"
    }
}
