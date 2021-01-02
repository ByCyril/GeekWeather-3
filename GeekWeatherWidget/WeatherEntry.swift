//
//  WeatherEntry.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import WidgetKit
import GWFoundation

struct WidgetWeatherModel {
    let location: String
    let temp: String
    let icon: String
    let lastUpdated: String
    let feelsLike: String
    let summary: String
    var currently: Currently? = nil
    var hourly: [Hourly]? = nil
    var daily: [Daily]? = nil
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    var weatherModel: WidgetWeatherModel
    var isPlaceholder = false
}

struct MockHourly {
    var hourly = [Hourly]()
    
    init() {
        
    }
}

extension WeatherEntry {
    
    static var stub: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose, CA", temp: "71°", icon: "01d", lastUpdated: "Last Updated 9:01 AM", feelsLike: "Feels like 68°", summary: "Sunny"))
    }
    
    static var placeholder: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose, CA", temp: "71°", icon: "01d", lastUpdated: "Last Updated 9:01 AM", feelsLike: "Feels like 62°", summary: "Sunny"), isPlaceholder: true)
    }
}
