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
    var location: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Developed and designed by Cyril")
                    .foregroundColor(.white)
                    .font(Font.custom("AvenirNext-Medium", size: 20))
            }
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 35) {
                    Spacer()
                    LevelOneView(weatherModel: weatherModel, location: location).padding()
                    LevelTwoView(weatherModel: weatherModel)
                    LevelThreeView(weatherModel: weatherModel).padding()
                }
            }
       
        }
    }

}

struct iPadMainView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(),location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
    }
}
