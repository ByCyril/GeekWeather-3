//
//  LevelThreeView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

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
        VStack {
            HStack {
                LevelThreeCell(title: "Sunrise", value: "7:21 AM")
                LevelThreeCell(title: "Sunset", value: "7:21 AM")
                LevelThreeCell(title: "Dew Point", value: "7:21 AM")
                LevelThreeCell(title: "Chance of Rain", value: "7:21 AM")
            }
            HStack {
                LevelThreeCell(title: "Sunrise", value: "7:21 AM")
                LevelThreeCell(title: "Sunset", value: "7:21 AM")
                LevelThreeCell(title: "Dew Point", value: "7:21 AM")
                LevelThreeCell(title: "Chance of Rain", value: "7:21 AM")
            }
        }
    }
}

struct LevelThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            LevelThreeView(weatherModel: Mocks.mock())
        }.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
