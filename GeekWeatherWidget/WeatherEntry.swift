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
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    var weatherModel: WidgetWeatherModel

    var isPlaceholder = false
}

extension WeatherEntry {
    
    static var stub: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose", temp: "71°", icon: "01d", lastUpdated: "Last Updated 9:01 AM", feelsLike: "Feels like 68°", summary: "Clear skies"))
    }
    
    static var placeholder: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose", temp: "64°", icon: "01d", lastUpdated: "Last Updated 9:01 AM", feelsLike: "Feels like 62°", summary: "Clear Skies"), isPlaceholder: true)
    }
}
