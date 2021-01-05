//
//  LevelTwoView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct LevelTwoView: View {
    
    var weatherModel: WeatherModel
    
    var body: some View {
    
        VStack(alignment: .center, spacing: 35) {
            HourlyView(hourly: weatherModel.hourly)
            DailyView(daily: weatherModel.daily)
        }
    }
}

struct LevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
