//
//  GeekWeatherWidget.swift
//  GeekWeatherWidget
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct GeekWeatherWidget: Widget {
    let kind: String = "GeekWeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayViewTimelineProvider()) { entry in
            GeekWeatherWidgetEntryView(entry: entry)
        }.supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("GeekWeather Widget")
        .description("Developed and designed by Cyril")
    }
}

struct GeekWeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        GeekWeatherWidgetEntryView(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
