//
//  RequestURL.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation

public struct RequestURL {
    var base = "https://api.openweathermap.org/data/2.5/onecall"

    var location: CLLocation
    
    var appId = "appid=79048569b8ad1fa5c026d1be99adc0cd" {
        didSet {
            appId = "appid=\(appId)"
        }
    }
    
    var exclude = "exclude=minutely" {
        didSet {
            exclude = "exclude=\(exclude)"
        }
    }
    
    public init(location: CLLocation) {
        self.location = location
    }
    
    public var url: URL {
        let lon = "lon=\(location.coordinate.longitude)"
        let lat = "lat=\(location.coordinate.latitude)"
        if let customAPIID = sharedUserDefaults?.string(forKey: "CustomAPIID") {
            return URL(string: "\(base)?\(lat)&\(lon)&\(customAPIID)&\(exclude)")!
        } else {
            return URL(string: "\(base)?\(lat)&\(lon)&\(appId)&\(exclude)")!
        }
    }
}
