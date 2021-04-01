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
    static let suiteName: String = "group.com.ByCyril.GeekWeather-2"
    
    struct Keys {
        static let is24Hour: String = "is24Hour"
        static let Units: String = "Units"
        static let Temperature: String = "Temperature"
        static let ExistingUser: String = "ExistingUser"
        static let LastUpdated: String = "LastUpdated"
        static let DefaultLocation: String = "DefaultLocation"
        static let WidgetDefaultLocation: String = "WidgetDefaultLocation"
        static let WidgetLastUpdated: String = "WidgetLastUpdated"
    }
}
