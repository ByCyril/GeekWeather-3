//
//  TodayViewSimpleWidget.swift
//  GeekWeatherWidgetExtension
//
//  Created by Cyril Garcia on 1/16/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewSimpleWidget: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            
            HStack {
                Image(entry.weatherModel.currently.weather.first!.icon)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(15).padding(.leading).padding(.trailing)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(entry.weatherModel.temp)
                        .font(Font.custom("AvenirNext-Bold", size: 50))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    Text(entry.weatherModel.summary)
                        .font(Font.custom("AvenirNext-Regular", size: 35))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: -12, leading: 0, bottom: 0, trailing: 0))
                    Text(entry.weatherModel.location)
                        .font(Font.custom("AvenirNext-Regular", size: 17))
                        .foregroundColor(.white)
                    
                }.padding(.leading)
                
            }
            
        }
    }
}

struct TodayViewSimpleWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewSimpleWidget(entry: .stub).previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)
    }
}
