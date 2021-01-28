//
//  LevelThreeView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
//import SwiftUILib_WrapStack

struct LevelThreeCell: View {
    var title: String
    var value: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(Font.custom("AvenirNext-Medium", size: 25))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                Text(value)
                    .font(Font.custom("AvenirNext-Medium", size: 35))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
            }.padding()
        }.background(Color.white.opacity(0.15)).cornerRadius(15)
    }
}

struct LevelThreeView: View {
    
    var weatherModel: WeatherModel
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                LevelThreeCell(title: "Sunrise", value: weatherModel.current.sunrise.convertTime().lowercased()).padding(.leading)
                LevelThreeCell(title: "Sunset", value: weatherModel.current.sunset.convertTime().lowercased())
                LevelThreeCell(title: "Dew Point", value: weatherModel.current.dew_point.kelvinToSystemFormat())
                LevelThreeCell(title: "Visibility", value: weatherModel.current.visibility.mToSystemFormat())
                LevelThreeCell(title: "Chance of Rain", value: weatherModel.daily.first!.pop.percentage(chop: false))
                LevelThreeCell(title: "Cloud Cover", value: weatherModel.current.clouds.percentage(chop: true))
                LevelThreeCell(title: "Humidity", value: weatherModel.current.humidity.percentage(chop: true))
                LevelThreeCell(title: "UV Index", value: weatherModel.current.uvi.stringRound())
                LevelThreeCell(title: "Wind Speed", value: weatherModel.current.wind_speed.msToSystemFormat())
                LevelThreeCell(title: "Pressure", value: weatherModel.current.pressure.stringRound()).padding(.trailing)
                
            }.padding(.bottom)
        }
    }
}

struct LevelThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))

        }.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
