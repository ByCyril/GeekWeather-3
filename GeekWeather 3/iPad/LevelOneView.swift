//
//  LevelOneView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct LevelOneView: View {
    
    var weatherModel: WeatherModel
    
    let imageSize: CGFloat = 175
    
    var body: some View {
        VStack(spacing: 0) {
//            Spacer()
            Text("San Jose, CA").font(Font.custom("AvenirNext-Medium", size: 45)).foregroundColor(.white).padding(.top)
                
            HStack {
                Image(weatherModel.current.weather.first!.icon)
                    .resizable().frame(width: imageSize, height: imageSize, alignment: .center)
                    .cornerRadius(15)
                
                Text(weatherModel.current.temp.kelvinToSystemFormat())
                    .font(Font.custom("AvenirNext-Bold", size: 75))
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }.padding(.leading).padding(.trailing)
            
            Text(weatherModel.daily.first!.weather.first!.description.capitalized).font(Font.custom("AvenirNext-Medium", size: 35)).foregroundColor(.white).padding(.top)
//            Spacer()
        }
    }
}

struct LevelOneView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock()).previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}