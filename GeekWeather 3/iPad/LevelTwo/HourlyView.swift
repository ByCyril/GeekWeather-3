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
                .resizable().frame(width: 65, height: 65, alignment: .center)
                .cornerRadius(15)
           
            Text(temp)
                .font(Font.custom("AvenirNext-Bold", size: 25))
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.2)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
        }.padding(.leading)
        
    }
}

struct HourlyView: View {
    var hourly: [Hourly]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 25) {
                ForEach(0..<hourly.count) { i in
                    let hour = hourly[i]
                    
                    let icon = hour.weather.first!.icon
                    if icon == "sunset" || icon == "sunrise" {
                        HourlyViewCell(time: hour.dt.convertTime(),
                                       icon: hour.weather.first!.icon,
                                       temp: icon)
                    } else {
                        HourlyViewCell(time: hour.dt.convertHourTime(),
                                       icon: hour.weather.first!.icon,
                                       temp: hour.temp.kelvinToSystemFormat())
                    }
                }
            }
        }
    }
}


struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
