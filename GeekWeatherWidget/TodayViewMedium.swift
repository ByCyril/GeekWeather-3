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
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text(entry.weatherModel.location)
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                        Text(entry.weatherModel.temp)
                            .font(Font.custom("AvenirNext-Bold", size: 35))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                    }.padding(.leading).padding(.top)
                    Spacer()
                    VStack(spacing: 0) {
                        Image(entry.weatherModel.icon)
                            .resizable().frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(15)
                        Text(entry.weatherModel.summary)
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                        Spacer()
                    }.padding(.trailing).padding(.top)
                }

                  HStack {
                    if let hourly = entry.weatherModel.hourly {
                        ForEach(0..<7) { i in
                            let data = hourly[i]
                            VStack(spacing: 0) {
                                Text(data.dt.convertHourTime())
                                    .font(Font.custom("AvenirNext-Regular", size: 13))
                                    .minimumScaleFactor(0.2)
                                    .allowsTightening(true)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                                Image(entry.weatherModel.icon)
                                    .resizable().frame(width: 25, height: 25, alignment: .center)
                                    .cornerRadius(15)
                                Text(data.temp.kelvinToSystemFormat())
                                    .font(Font.custom("AvenirNext-Bold", size: 13))
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.2)
                                    .allowsTightening(true)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                            }
                          Divider()
                        }
                    }
                  }.padding(.leading).padding(.trailing)
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



