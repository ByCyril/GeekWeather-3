//
//  TodayViewLarge.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/valueTextSize.
//  Copyright © valueTextSizevalueTextSize ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayViewLarge: View {
    
    let entry: WeatherEntry
    
    let smallTextSize: CGFloat = 12
    let valueTextSize: CGFloat = 17
    let smallFontWeight: String = "Medium"
    let valueFontWeight: String = "Heavy"
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 0) {
                HStack {
                    Image(entry.weatherModel.icon)
                        .resizable().frame(width: 65, height: 65, alignment: .center)
                        .cornerRadius(15)
                    Text("\(entry.weatherModel.summary) with a high \(entry.weatherModel.daily?.first?.temp.max.kelvinToSystemFormat() ?? "68°") and a low of  \(entry.weatherModel.daily?.first?.temp.min.kelvinToSystemFormat() ?? "45°").")
                        .font(Font.custom("AvenirNext-Medium", size: 17))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .foregroundColor(Color.white)
                }.padding(.top).padding(.leading).padding(.trailing)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Sunrise").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.sunrise.convertTime() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Dew Point").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.currently?.dew_point.kelvinToSystemFormat() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Chance of Rain").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.pop.percentage(chop: true) ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Humidity").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.humidity.percentage(chop: true) ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Wind Speed").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.currently?.wind_speed.msToSystemFormat() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                    }.padding(.leading).padding(.trailing).padding(.bottom)
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Sunset").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.sunset.convertTime() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Visibility").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.currently?.visibility.mToSystemFormat() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Cloud Cover").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.clouds.percentage(chop: true) ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("UV Index").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.daily?.first?.uvi.stringRound() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Pressure").font(Font.custom("AvenirNext-\(smallFontWeight)", size: smallTextSize)).foregroundColor(.white)
                            Text(entry.weatherModel.currently?.pressure.stringRound() ?? "NA ☹️").font(Font.custom("AvenirNext-\(valueTextSize)", size: valueTextSize)).foregroundColor(.white)
                        }
                    }.padding(.leading).padding(.trailing).padding(.bottom)
                    Spacer()
                }
                
            }
            
        }
        .redacted(reason: entry.isPlaceholder ? .placeholder : .init())
        
    }
    
}

@available(iOS 14.0, *)
struct TodayViewLarge_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewLarge(entry: .stub)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .environment(\.colorScheme, .dark)
    }
}



