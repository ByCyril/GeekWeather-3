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
        .configurationDisplayName("Small GeekWeather Widget")
        .description("Simple widget")
    }
}

struct GeekWeatherLargeLabeledWidget: Widget {
    let kind: String = "GeekWeatherLargeLabeledWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            LargeLabeledWidget(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("Small GeekWeather Widget")
        .description("Simple widget with large label")
    }
}

struct GeekWeatherSmallSummaryWidget: Widget {
    let kind: String = "GeekWeatherSmallSummaryWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            SummaryWidgetView(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("Small GeekWeather Widget")
        .description("Simple summary widget")
    }
}

struct GeekWeatherSmallDetailedWidget: Widget {
    let kind: String = "GeekWeatherSmallDetailedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            DetailedSmallView(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("Small GeekWeather Widget")
        .description("Simple widget with daily view")
    }
}

struct GeekWeatherMediumDetailedWidget: Widget {
    let kind: String = "GeekWeatherMediumDetailedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            TodayViewMedium(entry: entry)
        }.supportedFamilies([.systemMedium])
        .configurationDisplayName("Medium GeekWeather Widget")
        .description("Detailed Medium Widget")
    }
}
