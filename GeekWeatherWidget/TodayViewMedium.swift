//
//  TodayViewMedium.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewMedium: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientTopColor"),Color("GradientBottomColor")]), startPoint: .top, endPoint: .bottom)

            VStack {
                
                HStack {
                    Image(entry.weatherModel.icon).resizable().frame(width: 65, height: 65, alignment: .center).padding(.leading, 5)
                    
                    VStack(alignment: .leading, spacing: nil, content: {
                        Text(entry.weatherModel.location).font(Font.custom("HelveticaNeue-light", size: 17))
                        Text(entry.weatherModel.temp).font(Font.custom("HelveticaNeue", size: 40))
                    }).padding()
                                        
                    VStack {
                        Spacer()
                        Text(entry.weatherModel.lastUpdated).font(Font.custom("HelveticaNeue-light", size: 12)).padding(.bottom)
                        
                        Text(entry.weatherModel.summary).font(Font.custom("HelveticaNeue", size: 15)).padding(.bottom, 1)
                        Text(entry.weatherModel.feelsLike).font(Font.custom("HelveticaNeue", size: 13))
                        Spacer()
                    }.padding(.trailing, 5)
                }
            }
            
        }.redacted(reason: entry.isPlaceholder ? .placeholder : .init())
    }
    
}

@available(iOS 14.0, *)
struct TodayViewMedium_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewMedium(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)
    }
}



