//
//  ContentView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct ErrorView: View {
    
    var error: WeatherFetcherError
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.octagon.fill").resizable().frame(width: 25, height: 25, alignment: .center).padding()
            Text(error.title).font(.callout).padding().multilineTextAlignment(.center)
        }
        Text(error.description)
    }
}

struct ContentView: View {
    
    var weatherModel: WeatherModel = Mocks.mock()
    @ObservedObject var weatherFetcher = WeatherFetcher()
    
    var body: some View {
        ZStack {
            ScrollView {
                if weatherFetcher.fetchError {
                    if let error = weatherFetcher.error.first {
                        ErrorView(error: error)
                    }
                } else {
                    if let model = self.weatherFetcher.weatherModel.first {
                        
                        LevelOneView(weatherModel: model, location: self.weatherFetcher.location)
                        Image(systemName: "chevron.compact.down")
                        LevelTwoView(weatherModel: model).padding()
                        LevelThreeView(weatherModel: model)
                    } else {
                        if let error = weatherFetcher.error.first {
                            ErrorView(error: error)
                        } else {
                            VStack(alignment: .center) {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text(self.weatherFetcher.currentStatus)
                            }
                        }
                    }
                }
            }.contextMenu {
                Button(action: {
                    // change country setting
                }) {
                    Text("Choose Country")
                    Image(systemName: "globe")
                }

                Button(action: {
                    // enable geolocation
                }) {
                    Text("Detect Location")
                    Image(systemName: "location.circle")
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
