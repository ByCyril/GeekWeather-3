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
        ZStack {
            HStack(spacing: 0) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(15)
                    .padding(.leading).padding(.trailing)
                
                Text(time)
                    .font(Font.custom("AvenirNext-Medium", size: 32))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                    .padding()
                
                Spacer()
                
                HStack(spacing: 10) {
                    Text(high + "   " + low)
                        .font(Font.custom("AvenirNext-Medium", size: 30))
                        .foregroundColor(Color.white)
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                }.padding(.trailing)
                
            }
        }.background(Color.white.opacity(0.15)).cornerRadius(20).padding(.leading)
        
    }
}

struct DailyView: View {
    
    var daily: [Daily]
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<daily.count) { i in
                let day = daily[i]
                
                let time = (i == 0) ? "Now" : day.dt.date(.day)
                
                DailyCellItem(time: time,
                              icon: day.weather.first!.icon,
                              high: day.temp.max.kelvinToSystemFormat(),
                              low: day.temp.min.kelvinToSystemFormat())
            }
        }.padding(.leading).padding(.trailing)
    }
}


struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
