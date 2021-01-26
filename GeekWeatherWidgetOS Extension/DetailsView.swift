//
//  DetailsView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/25/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI


struct DetailsView: View {

    var daily: Daily
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {

                        Image(daily.weather.first!.icon).resizable().frame(width: 55, height: 55, alignment: .center)
                        Text(daily.dt.date(.day))
                            .font(Font.custom("AvenirNext-Medium", size: 35))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                    Text(daily.weather.first!.description.capitalized)
                        .font(Font.custom("AvenirNext-Bold", size: 20))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(5)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        SmallItemDetailView(title: "Sunrise", value: daily.sunrise.convertTime().lowercased())
                        SmallItemDetailView(title: "Sunset", value: daily.sunset.convertTime().lowercased())
                    }
                    HStack {
                        SmallItemDetailView(title: "Chance of Rain", value: daily.pop.percentage(chop: false))
                    }
                    HStack {
                        SmallItemDetailView(title: "Cloud Cover", value: daily.clouds.percentage(chop: true))
                        SmallItemDetailView(title: "Humidity", value: daily.humidity.percentage(chop: true))
                    }
                    HStack {
                        SmallItemDetailView(title: "UV Index", value: daily.uvi.stringRound())
                        SmallItemDetailView(title: "Dew Point", value: daily.dew_point.kelvinToSystemFormat())
                    }
                    HStack {
                        
                        SmallItemDetailView(title: "Wind Speed", value: daily.wind_speed.msToSystemFormat())
                        
                    }
                    SmallItemDetailView(title: "Pressure", value: daily.pressure.stringRound() + " hPA")
                    
                }.padding(.bottom).navigationBarBackButtonHidden(false)
            }
        }
    }
}

struct Details_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        ForEach(0..<Mocks.mock().daily.count) { i in
            DetailsView(daily: Mocks.mock().daily[i]).previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
            }
        }
    }
    
}
