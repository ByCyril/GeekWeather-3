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
                if let error = weatherFetcher.error.first {
                    Image(systemName: "xmark.octagon.fill").resizable().frame(width: 75, height: 75, alignment: .center).padding()
                    Text(error.title).font(.title)
                    Text(error.description)
                }
                   
            } else {
                if let model = self.weatherFetcher.weatherModel.first {
                    LevelOneView(weatherModel: model, location: self.weatherFetcher.location)
                    Image(systemName: "chevron.compact.down")
                    LevelTwoView(weatherModel: model).padding()
                    LevelThreeView(weatherModel: model).padding()
                } else {
                    if let error = weatherFetcher.error.first {
                        Image(systemName: "xmark.octagon.fill").resizable().frame(width: 75, height: 75, alignment: .center).padding()
                        Text(error.title).font(.title)
                        Text(error.description)
                    }
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
