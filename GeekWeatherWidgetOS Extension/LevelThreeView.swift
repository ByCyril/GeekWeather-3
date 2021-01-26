//
//  LevelThreeView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct HorizontalItemView: View {
    
    var icon: String
    var date: String
    var highTemp: String
    var lowTemp: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(icon)
                .resizable().frame(width: 40, height: 40, alignment: .center)
            
            VStack(alignment: .leading) {
                
                Text(date)
                    .font(Font.custom("AvenirNext-Medium", size: 20))
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text(highTemp)
                        .font(Font.custom("AvenirNext-Bold", size: 20))
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                    Text(lowTemp)
                        .font(Font.custom("AvenirNext-Bold", size: 20))
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(Color.secondary)
                }
                
            }
            Spacer()
            Image(systemName: "chevron.compact.right")
        }
    }
}

struct LevelThreeView: View {
    let weatherModel: WeatherModel
        
    var body: some View {
        
        VStack(spacing: 15) {
            let daily = weatherModel.daily
            
            ForEach(0..<daily.count) { i in
                let day = daily[i]
                
                let date = (i == 0) ? "Now" : day.dt.date(.day)
                NavigationLink(
                    destination: DetailsView(daily: day),
                    label: {
                        HorizontalItemView(icon: day.weather.first!.icon,
                                           date: date,
                                           highTemp: day.temp.max.kelvinToSystemFormat(),
                                           lowTemp: day.temp.min.kelvinToSystemFormat())
                    })
            }
            
            NavigationLink(
                destination: SettingsView(),
                label: {
                    Text("Settings")
                })
            
        }
    }
}

struct LevelThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weatherModel: Mocks.mock())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
