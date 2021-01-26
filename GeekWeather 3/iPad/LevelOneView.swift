//
//  LevelOneView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct LevelOneView: View {
    
    var weatherModel: WeatherModel
    
    var location: String
    let imageSize: CGFloat = 125
    
    var body: some View {
        VStack(spacing: 10) {
            Text(location).font(Font.custom("AvenirNext-Medium", size: 45)).foregroundColor(.white).padding(.top).padding(.bottom)
                
            HStack(spacing: 25) {
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
            
            Text(weatherModel.daily.first!.weather.first!.description.capitalized)
                .font(Font.custom("AvenirNext-Medium", size: 25))
                .foregroundColor(.white).padding(.top)
            
            let high = weatherModel.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
            let low = weatherModel.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
            
            Text("⬆︎\(high)  ⬇︎\(low)")
                .font(Font.custom("AvenirNext-Medium", size: 25))
                .foregroundColor(.white)
            
        }
    }
}


struct LevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
