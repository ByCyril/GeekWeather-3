//
//  iPadMainView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct iPadMainView: View {
    
    var weatherModel: WeatherModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Spacer()
                LevelOneView(weatherModel: weatherModel)
                LevelTwoView(weatherModel: weatherModel)
                LevelThreeView(weatherModel: weatherModel).padding()
                
                Spacer()
            }
            
        }
        
    }
}

struct iPadMainView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock()).previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
