//
//  TodayViewDetailedMediumWidget.swift
//  GeekWeatherWidgetExtension
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewDetailedMediumWidget: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            Color("demo-background").ignoresSafeArea()
         
            HStack {
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack {
                        Image(entry.weatherModel.currently.weather.first!.icon)
                            .resizable()
                            .frame(width: 45, height: 45, alignment: .center)
                            .cornerRadius(15)
                        Text(entry.weatherModel.temp)
                            .font(Font.custom("AvenirNext-Bold", size: 35))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                     
                    Text(entry.weatherModel.location)
                        .font(Font.custom("AvenirNext-Regular", size: 17))
                        .foregroundColor(.white)
                    HStack {
                        HStack {
                            Image(systemName: "sunrise")
                                .resizable()
                                .frame(width: 22, height: 17, alignment: .center)
                                .foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.sunrise.convertTime().lowercased())
                                .font(Font.custom("AvenirNext-Medium", size: 15))
                                .foregroundColor(.white)
                        }
                        HStack {
                            Image(systemName: "sunset")
                                .resizable()
                                .frame(width: 22, height: 17, alignment: .center)
                                .foregroundColor(.white)
                            Text(entry.weatherModel.daily.first!.sunset.convertTime().lowercased())
                                .font(Font.custom("AvenirNext-Medium", size: 15))
                                .foregroundColor(.white)
                        }
                    }.padding(.top)
                }.padding()
                
                VStack(alignment: .leading, spacing: 15) {
                 
                    HStack {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 22, height: 17, alignment: .center)
                            .foregroundColor(.white)
                        Text(entry.weatherModel.currently.wind_speed.msToSystemFormat())
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Image(systemName: "cloud")
                            .resizable()
                            .frame(width: 22, height: 17, alignment: .center)
                            .foregroundColor(.white)
                        Text(entry.weatherModel.daily.first!.clouds.percentage(chop: true))
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "cloud.rain")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.white)
                        Text(entry.weatherModel.daily.first!.pop.percentage(chop: false))
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .foregroundColor(.white)
                    }
                    
                  
                    
                }
            }
        }
    }
}

struct TodayViewDetailedMediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewDetailedMediumWidget(entry: .stub).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
