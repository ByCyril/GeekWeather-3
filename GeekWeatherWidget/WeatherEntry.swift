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

extension WeatherEntry {
    
    static var stub: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "-", temp: "-", icon: "01d", lastUpdated: "-", feelsLike: "-", summary: "-"))
    }
    
    static var placeholder: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "-", temp: "-", icon: "01d", lastUpdated: "-", feelsLike: "-", summary: "-"), isPlaceholder: true)
    }
}
