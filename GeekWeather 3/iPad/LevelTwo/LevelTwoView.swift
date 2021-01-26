//
//  LevelTwoView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct LevelTwoView: View {
    
    var weatherModel: WeatherModel
    
    var body: some View {
    
        VStack(alignment: .center, spacing: 35) {
            HourlyView(hourly: weatherModel.hourly)
            DailyView(daily: weatherModel.daily)
        }
    }
}
