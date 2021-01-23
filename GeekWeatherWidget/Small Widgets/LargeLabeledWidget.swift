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
                        .frame(width: 75, height: 75, alignment: .center)
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
                        Text(entry.weatherModel.location).font(Font.custom("AvenirNext-Regular", size: 12))
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white).padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                    }.padding(.bottom).padding(.leading)
                    Spacer()
                }.padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
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
