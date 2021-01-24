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
    @Environment(\.scenePhase) private var scenePhase

    var weatherModel: WeatherModel = Mocks.mock()
    @ObservedObject var weatherFetcher = WeatherFetcher()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if weatherFetcher.fetchError {
                    if let error = weatherFetcher.error.first {
                        ErrorView(error: error)
                    }
                } else {
                    if let model = self.weatherFetcher.weatherModel.first {
                        
                        LevelOneView(weatherModel: model, location: self.weatherFetcher.location)
                        LevelTwoView(weatherModel: model).padding()
                        LevelThreeView(weatherModel: model)
                        VStack {
                            Text("Developed and Designed")
                            Text("by Cyril © 2017 - 2021")
                        }.font(Font.custom("AvenirNext-Medium", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                        .padding()
                    } else {
                        if let error = weatherFetcher.error.first {
                                ErrorView(error: error)
//                            LevelOneView(weatherModel: weatherModel, location: "Mountain View, CA")
//                            LevelTwoView(weatherModel: weatherModel).padding()
//                            LevelThreeView(weatherModel: weatherModel)
//
//                            VStack {
//                                Text("Developed and Designed")
//                                Text("by Cyril © 2017 - 2021")
//                            }.font(Font.custom("AvenirNext-Medium", size: 12))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color.white)
//                            .padding()
                                
                        } else {
                            VStack(alignment: .center) {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text(self.weatherFetcher.currentStatus)
                            }
                        }
                    }
                }
            }.onChange(of: scenePhase) { phase in
                switch phase {
                    case .active:
                        self.weatherFetcher.calculateLastUpdated()
                    default:
                        print(">> do something else in future")
                }
            }
        }.navigationTitle(self.weatherFetcher.lastUpdatedStr).onAppear {
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
