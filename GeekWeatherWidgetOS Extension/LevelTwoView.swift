//
//  LevelTwoView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct SmallItem: View {
    
    var topItem: String
    var icon: String
    var bottomItem: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(topItem)
                .font(Font.custom("AvenirNext-Medium", size: 20))
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            Image(icon)
                .resizable().frame(width: 45, height: 45, alignment: .center)
            Text(bottomItem)
                .font(Font.custom("AvenirNext-Bold", size: 25))
                .foregroundColor(Color.white)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
        }
    }
}

struct LevelTwoView: View {
    
    let weatherModel: WeatherModel
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                let hourly = weatherModel.hourly
                
                ForEach(0..<20) { i in
                    let hour = hourly[i]
                    let icon = hour.weather.first!.icon
                    
                    if (icon == "sunrise" || icon == "sunset") {
                        let time = hour.dt.convertTime()
                        SmallItem(topItem: time,
                                  icon: icon,
                                  bottomItem: icon.capitalized).frame(width: 50)
                    } else {
                        let time = (i == 0) ? "Now" : hour.dt.convertHourTime()
                        SmallItem(topItem: time,
                                  icon: icon,
                                  bottomItem: hour.temp.kelvinToSystemFormat())
                    }
                }
                
            }
        }
        
    }
}

struct LevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        LevelTwoView(weatherModel: Mocks.mock())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
