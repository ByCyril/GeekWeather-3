//
//  HourlyView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct HourlyCellView: View {
    var time: String
    var icon: String
    var temp: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                Text(time)
                    .font(Font.custom("AvenirNext-Medium", size: 25))
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
            }.padding()
        }.background(Color.white.opacity(0.15))
        .cornerRadius(20)
        
    }
}

struct HourlyView: View {
    var hourly: [Hourly]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(0..<20) { i in
                    let hour = hourly[i]
                    let icon = hour.weather.first!.icon
                    if i == 0 {
                        HourlyCellView(time: "Now",
                                       icon: hour.weather.first!.icon,
                                       temp: hour.temp.kelvinToSystemFormat()).padding(.leading)
                    } else {
                        if icon == "sunset" || icon == "sunrise" {
                            if i == 19 {
                                HourlyCellView(time: hour.dt.convertTime(),
                                               icon: hour.weather.first!.icon,
                                               temp: icon.capitalized)
                                    .padding(.trailing)
                            } else {
                                HourlyCellView(time: hour.dt.convertTime(),
                                               icon: hour.weather.first!.icon,
                                               temp: icon.capitalized)
                            }
                            
                        } else {
                            if i == 19 {
                                HourlyCellView(time: hour.dt.convertHourTime(),
                                               icon: hour.weather.first!.icon,
                                               temp: hour.temp.kelvinToSystemFormat())
                                    .padding(.trailing)
                            } else {
                                HourlyCellView(time: hour.dt.convertHourTime(),
                                               icon: hour.weather.first!.icon,
                                               temp: hour.temp.kelvinToSystemFormat())
                            }
                        }
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
