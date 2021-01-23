//
//  ContentView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct ContentView: View {
    
    var weatherModel: WeatherModel = Mocks.mock()
    
    var body: some View {
        ScrollView {
            LevelOneView(weatherModel: weatherModel)
            LevelTwoView(weatherModel: weatherModel).padding()
            LevelThreeView(weatherModel: weatherModel).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weatherModel: Mocks.mock())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
