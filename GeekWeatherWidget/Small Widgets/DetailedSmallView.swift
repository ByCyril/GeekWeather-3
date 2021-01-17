//
//  DetailedSmallView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/16/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct DetailedSmallView: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text(entry.weatherModel.location).font(Font.custom("AvenirNext-Medium", size: 12)).foregroundColor(.white).padding(.top)
                    Spacer()
                HStack {
                    Image(entry.weatherModel.icon)
                        .resizable().frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(15)
                    
                    Text(entry.weatherModel.temp)
                        .font(Font.custom("AvenirNext-Bold", size: 30))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                }.padding(.leading).padding(.trailing)
                Spacer()
                HStack(spacing: 8) {
                    if let hourly = entry.weatherModel.hourly {
                        let numOfItems = 4
                        
                        ForEach(0..<numOfItems) { i in
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
    }
}

struct DetailedSmallView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedSmallView(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
    }
}
