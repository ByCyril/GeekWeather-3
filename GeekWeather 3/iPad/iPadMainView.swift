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
    
//    @ObservedObject var weatherFetcher = WeatherFetcher()
    
    var weatherModel: WeatherModel = Mocks.mock()
    var location: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 35) {
                    Spacer()
                    LevelOneView(weatherModel: weatherModel, location: location).padding()
                    LevelThreeView(weatherModel: weatherModel)
                    LevelTwoView(weatherModel: weatherModel)
                    
                    Spacer()
                    Text("Developed and designed by Cyril © 2017 - 2021")
                        .foregroundColor(.white)
                        .font(Font.custom("AvenirNext-Medium", size: 20))
                        .padding(.bottom)
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
