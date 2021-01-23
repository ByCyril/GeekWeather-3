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
    @ObservedObject var weatherFetcher = WeatherFetcher()
    
    var body: some View {
        ScrollView {
            if weatherFetcher.fetchError {
                Text("Error up here")
            } else {
                if let model = self.weatherFetcher.weatherModel.first {
                    LevelOneView(weatherModel: model)
                    LevelTwoView(weatherModel: model).padding()
                    LevelThreeView(weatherModel: model).padding()
                } else {
                    Text("Error here")
                }
            }
            
        }.onAppear {
            self.weatherFetcher.fetch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weatherModel: Mocks.mock())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
