//
//  ComplicationForecastView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/23/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import ClockKit
import GWFoundation

struct ComplicationItem: View {

    var topItem: String
    var icon: String
    var bottomItem: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(topItem)
                .font(Font.custom("AvenirNext-Medium", size: 10))
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
            Image(icon)
                .resizable().frame(width: 20, height: 20, alignment: .center)
            Text(bottomItem)
                .font(Font.custom("AvenirNext-Bold", size: 12))
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.2)
                .allowsTightening(true)
                .lineLimit(1)
                .foregroundColor(Color.white)
        }
    }
}

struct ComplicationForecastView: View {
    
    let weatherModel: WeatherModel = Mocks.mock()
    
    var body: some View {
        
        VStack {
            HStack {
                Text("San Jose, CA").font(Font.custom("AvenirNext-Bold", size: 12))
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.2)
                                    .allowsTightening(true)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                Spacer()
            }
            HStack(spacing: 6) {
                ForEach(0..<6) { i in
                    let hour = weatherModel.hourly[i]
                    ComplicationItem(topItem: hour.dt.convertHourTime(),
                                     icon: hour.weather.first!.icon,
                                     bottomItem: hour.temp.kelvinToSystemFormat())
                }
            }
        }
        
    }
}

struct ComplicationForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ComplicationForecastView()
            
            CLKComplicationTemplateGraphicRectangularFullView(ComplicationForecastView()).previewContext()
            
        }
    }
}
