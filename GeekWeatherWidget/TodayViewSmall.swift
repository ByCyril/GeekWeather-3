//
//  TodayViewSmall.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewSmall: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientTopColor"),Color("GradientBottomColor")]), startPoint: .top, endPoint: .bottom)

            VStack {
                Spacer()
                Text(entry.weatherModel.location).font(Font.custom("AvenirNext", size: 15))
                    
                HStack {
                    Image(entry.weatherModel.icon).resizable().frame(width: 50, height: 50, alignment: .center)
                    Text(entry.weatherModel.temp).font(Font.custom("AvenirNext-Medium", size: 45))
                }
                                
                Text(entry.weatherModel.lastUpdated).font(Font.custom("AvenirNext", size: 10)).padding()
                
                
            }
        }
        .redacted(reason: entry.isPlaceholder ? .placeholder : .init())
        
    }
}

@available(iOS 14.0, *)
struct TodayViewSmall_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewSmall(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
    }
}
