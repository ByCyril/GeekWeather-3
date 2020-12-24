//
//  TodayView.swift
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
}

struct TodayViewEntry: TimelineEntry {
    var date: Date
    var weatherModel: WidgetWeatherModel

    var isPlaceholder = false
}

extension TodayViewEntry {
    
    static var stub: TodayViewEntry {
        TodayViewEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "Sunnyvale, CA", temp: "66°", icon: "02n", lastUpdated: "Last Updated: 12min ago"))
    }
    
    static var placeholder: TodayViewEntry {
        TodayViewEntry(date: Date(), weatherModel: WidgetWeatherModel(location: "San Jose, CA", temp: "64°", icon: "02d", lastUpdated: "Last Updated: 5min ago"), isPlaceholder: true)
    }
}
