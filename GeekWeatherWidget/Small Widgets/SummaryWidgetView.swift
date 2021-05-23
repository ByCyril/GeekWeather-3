//
//  SummaryWidgetView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/16/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SummaryWidgetView: View {
    
    let entry: WeatherEntry
    
    var body: some View {
        ZStack {
            Color("demo-background").ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.weatherModel.summary)
                            .font(Font.custom("AvenirNext-Bold", size: 75))
                            .lineLimit(3)
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                       
                    }.padding()
                    Spacer()
                }
            }
        }
    }
}

struct SummaryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryWidgetView(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
        
    }
}
