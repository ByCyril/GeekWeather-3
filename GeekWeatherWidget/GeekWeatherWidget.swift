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
            TodayViewSmall(entry: entry)
        }
    }
}

struct GeekWeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewSmall(entry: TodayViewEntry.stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
