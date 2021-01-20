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

struct GeekWeatherDetailedTodayWidget: Widget {
    let kind: String = "GeekWeatherDetailedTodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            DetailedTodayView(entry: entry)
        }.supportedFamilies([.systemSmall])
        .configurationDisplayName("GeekWeather Widget")
        .description("Detailed Today View")
    }
}

struct GeekWeatherMediumDetailedWidget: Widget {
    let kind: String = "GeekWeatherMediumDetailedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            TodayViewMedium(entry: entry)
        }.supportedFamilies([.systemMedium])
        .configurationDisplayName("GeekWeather Widget")
        .description("Detailed Medium Widget")
    }
}

struct GeekWeatherMediumSimpleWidget: Widget {
    let kind: String = "GeekWeatherMediumSimpleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            TodayViewSimpleWidget(entry: entry)
        }.supportedFamilies([.systemMedium])
        .configurationDisplayName("GeekWeather Widget")
        .description("Simple Medium Widget")
    }
}

struct GeekWeatherMediumMoreDetailedWidget: Widget {
    let kind: String = "GeekWeatherMediumMoreDetailedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            TodayViewDetailedMediumWidget(entry: entry)
        }.supportedFamilies([.systemMedium])
        .configurationDisplayName("GeekWeather Widget")
        .description("More Detailed Medium Widget")
    }
}
