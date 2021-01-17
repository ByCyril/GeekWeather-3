//
//  LargeLabeledWidget.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/16/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LargeLabeledWidget: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Image(entry.weatherModel.currently.weather.first!.icon).resizable()
                        .frame(width: 45, height: 45, alignment: .center)
                        .cornerRadius(15).padding(.top).padding(.trailing)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.weatherModel.temp)
                            .font(Font.custom("AvenirNext-Bold", size: 50))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        Text(entry.weatherModel.location).font(Font.custom("AvenirNext", size: 12))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }.padding(.bottom).padding(.leading)
                    Spacer()
                }
                
            }
        }
    }
}

struct IconedWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LargeLabeledWidget(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
    }
}
