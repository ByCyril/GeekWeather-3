//
//  GeekWeatherWidget.swift
//  GeekWeatherWidget
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import WidgetKit
import SwiftUI

struct GeekWeatherSmallWidget: Widget {
    let kind: String = "GeekWeatherSmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            TodayViewSmall(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("GeekWeather Widget")
        .description("Today View")
    }
}

struct GeekWeatherLargeLabeledWidget: Widget {
    let kind: String = "GeekWeatherLargeLabeledWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            LargeLabeledWidget(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("GeekWeather Widget")
        .description("Today View Large Label")
    }
}


struct GeekWeatherSmallDetailedWidget: Widget {
    let kind: String = "GeekWeatherSmallDetailedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            DetailedSmallView(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("GeekWeather Widget")
        .description("Detailed Today View")
    }
}


