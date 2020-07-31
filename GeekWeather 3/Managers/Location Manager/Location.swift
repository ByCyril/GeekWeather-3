//
//  Location.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    var location: CLLocation
    
    var latitude: String {
        return "\(location.coordinate.latitude)"
    }
    
    var longitude: String {
        return "\(location.coordinate.longitude)"
    }
}
