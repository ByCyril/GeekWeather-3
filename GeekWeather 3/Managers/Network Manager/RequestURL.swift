//
//  RequestURL.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

struct RequestURL {
    var base = "https://api.openweathermap.org/data/2.5/onecall"

    var location: Location
    var unit: Unit
    
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
    
    var url: URL {
        let lon = "lon=" + location.longitude
        let lat = "lat=" + location.latitude
        return URL(string: "\(base)?\(lat)&\(lon)&\(appId)&\(unit.rawValue)&\(exclude)")!
    }
}
