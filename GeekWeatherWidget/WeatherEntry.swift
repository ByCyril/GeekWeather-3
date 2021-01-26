//
//  WeatherEntry.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import WidgetKit


struct WidgetWeatherModel {
    let location: String
    let temp: String
    let icon: String
    let lastUpdated: String
    let feelsLike: String
    let summary: String
    var currently: Currently
    var hourly: [Hourly]
    var daily: [Daily]
    var alerts: [Alert]?
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    var weatherModel: WidgetWeatherModel
    var isPlaceholder = false
}

extension WeatherEntry {
    
    static var stub: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose, CA", temp: "71°", icon: "01d", lastUpdated: "-", feelsLike: "-", summary: "Clear Sky", currently: Mocks.mock().current, hourly: Mocks.mock().hourly, daily: Mocks.mock().daily, alerts: Mocks.mock().alerts))
    }
    
    static var placeholder: WeatherEntry {
        WeatherEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose, CA", temp: "71°", icon: "01d", lastUpdated: "-", feelsLike: "-", summary: "-", currently: Mocks.mock().current, hourly: Mocks.mock().hourly, daily: Mocks.mock().daily, alerts: Mocks.mock().alerts), isPlaceholder: true)
    }
}
