//
//  GeekWeatherWidgetEntryView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
struct GeekWeatherWidgetEntryView: View {
    
    let entry: WeatherEntry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            TodayViewSmall(entry: entry)
        case .systemMedium:
            TodayViewMedium(entry: entry)
        case .systemLarge:
            TodayViewLarge(entry: entry)
        default:
            Text("")
        }
    }
}

@available(iOS 14.0, *)
struct GeekWeatherWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GeekWeatherWidgetEntryView(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)
    }
}
