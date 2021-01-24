//
//  TodayViewMedium.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewSmallitem: View {
    
    var time: String
    var icon: String
    var date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(time.lowercased())
                .font(Font.custom("AvenirNext-Medium", size: 12))
                .minimumScaleFactor(0.2)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            Image(icon)
                .resizable().frame(width: 23, height: 23, alignment: .center)
            Text(date)
                .font(Font.custom("AvenirNext-Bold", size: 12))
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.2)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
        }
    }
}

struct TodayViewMedium: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 15) {
                        Image(entry.weatherModel.icon)
                            .resizable().frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(15)
                        Text(entry.weatherModel.temp)
                            .font(Font.custom("AvenirNext-Bold", size: 35))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                        
                    }.padding(.leading).padding(.top)
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text(entry.weatherModel.summary)
                            .font(Font.custom("AvenirNext-Medium", size: 21))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                         Text(entry.weatherModel.location)
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                    }.padding(.trailing).padding(.top)
                }.padding()
                
                HStack(spacing: 15) {
                    if let hourly = entry.weatherModel.hourly {
                        let numOfItems = 8
                        
                        ForEach(1..<numOfItems) { i in
                            let data = hourly[i]
                            let icon = data.weather.first!.icon
                            
                            if (icon == "sunrise" || icon == "sunset") {
                                let time = data.dt.convertTime()
                                TodayViewSmallitem(time: time,
                                                   icon: icon,
                                                   date: icon.capitalized).frame(width: 50)
                            } else {
                                let time = (i == 0) ? "Now" : data.dt.convertHourTime()
                                TodayViewSmallitem(time: time, icon: icon, date: data.temp.kelvinToSystemFormat())
                            }
                        }
                    }
                }.padding(.leading).padding(.trailing).padding(.bottom)
            }
            
        }
        .redacted(reason: entry.isPlaceholder ? .placeholder : .init())
        
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



