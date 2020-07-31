//
//  Weather.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

struct Weather {
    var currently: Currently
    var daily: Daily
    var hourly: Hourly
}

struct Currently {
    var timestamp: TimeInterval
}

struct Daily {
    var timestamp: TimeInterval
}

struct Hourly {
    var timestamp: TimeInterval
}
