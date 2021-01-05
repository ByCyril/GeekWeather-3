//
//  DailyView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct DailyCellItem: View {
    
    var time: String
    var icon: String
    var high: String
    var low: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(time)
                .font(Font.custom("AvenirNext-Medium", size: 25))
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            Image(icon)
                .resizable().frame(width: 75, height: 75, alignment: .center)
                .cornerRadius(15)
           
            HStack(spacing: 5) {
                Text(high)
                    .font(Font.custom("AvenirNext-Bold", size: 25))
                    .foregroundColor(Color.white)
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                
                Text(low)
                    .font(Font.custom("AvenirNext-Medium", size: 24))
                    .foregroundColor(Color.white)
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
            }
            
        }
        
    }
}

struct DailyView: View {
    
    var daily: [Daily]
    
    var body: some View {
        HStack {
            ForEach(0..<daily.count) { i in
                let day = daily[i]
                DailyCellItem(time: day.dt.date(.shortDay),
                              icon: day.weather.first!.icon,
                              high: day.temp.max.kelvinToSystemFormat(),
                              low: day.temp.min.kelvinToSystemFormat())
                
                if i < daily.count - 1{
                    Divider()
                }
            }
        }.padding(.leading).padding(.trailing)
    }
}
