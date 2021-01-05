//
//  HourlyView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct HourlyViewCell: View {
    var time: String
    var icon: String
    var temp: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(time)
                .font(Font.custom("AvenirNext-Medium", size: 20))
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            Image(icon)
                .resizable().frame(width: 75, height: 75, alignment: .center)
                .cornerRadius(15)
           
            Text(temp)
                .font(Font.custom("AvenirNext-Bold", size: 25))
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.2)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
        }
        
    }
}

struct HourlyView: View {
    var hourly: [Hourly]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(0..<hourly.count) { i in
                    let hour = hourly[i]
                    HourlyViewCell(time: hour.dt.convertHourTime(),
                                   icon: hour.weather.first!.icon,
                                   temp: hour.temp.kelvinToSystemFormat())
                    
                    if i < hourly.count - 1{
                        Divider()
                    }
                }
            }
        }
    }
}
