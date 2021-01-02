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
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)

            VStack {
                Spacer()
                Text(entry.weatherModel.location).font(Font.custom("AvenirNext-Medium", size: 15)).foregroundColor(.white)
                    
                HStack {
                    Image(entry.weatherModel.icon)
                        .resizable().frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(15)
                    
                    Text(entry.weatherModel.temp)
                        .font(Font.custom("AvenirNext-Bold", size: 40))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                }.padding(.leading).padding(.trailing)
                
                Text(entry.weatherModel.summary).font(Font.custom("AvenirNext-Medium", size: 12)).foregroundColor(.white)
                Spacer()
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
