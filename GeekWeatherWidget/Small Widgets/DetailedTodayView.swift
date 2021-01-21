//
//  DetailedTodayView.swift
//  GeekWeatherWidgetExtension
//
//  Created by Cyril Garcia on 1/17/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct DetailedTodayView: View {
    
    let entry: WeatherEntry
    let imageSize: CGFloat = 40
    let smallIcon: CGFloat = 12
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                    Text(entry.weatherModel.location)
                        .font(Font.custom("AvenirNext-Medium", size: 12))
                        .foregroundColor(.white)
                    HStack {
                        Image(entry.weatherModel.icon)
                            .resizable()
                            .frame(width: imageSize, height: imageSize, alignment: .center)
                        
                        Text(entry.weatherModel.temp)
                            .font(Font.custom("AvenirNext-Bold", size: 30))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                    
                }
                Spacer()
                VStack(spacing: 0) {
                    HStack {
                        HStack {
                            Image(systemName: "sunrise")
                                .resizable()
                                .frame(width: 15, height: 12, alignment: .center).foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.sunrise.convertTime().lowercased()).font(Font.custom("AvenirNext-Medium", size: 12)).foregroundColor(.white)
                        }
                        HStack {
                            Image(systemName: "sunset")
                                .resizable()
                                .frame(width: 15, height: 12, alignment: .center).foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.sunset.convertTime().lowercased()).font(Font.custom("AvenirNext-Medium", size: 12)).foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 15, height: 12, alignment: .center).foregroundColor(.white)
                        Text(entry.weatherModel.daily.first!.wind_speed.msToSystemFormat()).font(Font.custom("AvenirNext-Medium", size: 12)).foregroundColor(.white)
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    
                    HStack {
                        HStack {
                            Image(systemName: "cloud.rain")
                                .resizable()
                                .frame(width: 15, height: 15, alignment: .center)
                                .foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.pop.percentage(chop: false)).font(Font.custom("AvenirNext-Medium", size: 12))
                                .foregroundColor(.white)
                        }
                        HStack {
                            Image(systemName: "cloud")
                                .resizable()
                                .frame(width: 15, height: 12, alignment: .center)
                                .foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.clouds.percentage(chop: true))
                                .font(Font.custom("AvenirNext-Medium", size: 12))
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
            
            
        }.redacted(reason: entry.isPlaceholder ? .placeholder : .init())
        
    }
}

@available(iOS 14.0, *)
struct DetailedTodayView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTodayView(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .light)
    }
}
