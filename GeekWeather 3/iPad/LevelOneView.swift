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
    
    var location: String
    let imageSize: CGFloat = 175
    
    var body: some View {
        VStack(spacing: 0) {
            Text(location).font(Font.custom("AvenirNext-Medium", size: 45)).foregroundColor(.white).padding(.top)
                
            HStack {
                Image(weatherModel.current.weather.first!.icon)
                    .resizable().frame(width: imageSize, height: imageSize, alignment: .center)
                    .cornerRadius(15)
                
                Text(weatherModel.current.temp.kelvinToSystemFormat())
                    .font(Font.custom("AvenirNext-Heavy", size: 75))
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(.white)
            
            }.padding(.leading).padding(.trailing)
            
            Text(weatherModel.daily.first!.weather.first!.description.capitalized)
                .font(Font.custom("AvenirNext-Medium", size: 35))
                .foregroundColor(.white).padding(.top)
            Text("Feels like " + weatherModel.current.feels_like.kelvinToSystemFormat())
                .font(Font.custom("AvenirNext-Medium", size: 35))
                .foregroundColor(.white).padding(.top)
            
        }
    }
}


struct LevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
