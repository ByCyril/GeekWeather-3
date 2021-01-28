//
//  DailyView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct DailyDetailedCellItem: View {
    var day: Daily
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                SmallItemDetailView(title: "Sunrise", value: day.sunrise.convertTime().lowercased(), titleFontSize: 25, valueFontSize: 32).padding(.leading)
                SmallItemDetailView(title: "Sunset", value: day.sunset.convertTime().lowercased(), titleFontSize: 25, valueFontSize: 32)
                SmallItemDetailView(title: "Chance of Rain", value: day.pop.percentage(chop: false), titleFontSize: 25, valueFontSize: 32)
           
                SmallItemDetailView(title: "Cloud Cover", value: day.clouds.percentage(chop: true), titleFontSize: 25, valueFontSize: 32)
                SmallItemDetailView(title: "Humidity", value: day.humidity.percentage(chop: true), titleFontSize: 25, valueFontSize: 32)
                SmallItemDetailView(title: "UV Index", value: day.uvi.stringRound(), titleFontSize: 25, valueFontSize: 32)
         
                SmallItemDetailView(title: "Dew Point", value: day.dew_point.kelvinToSystemFormat(), titleFontSize: 25, valueFontSize: 32)
                SmallItemDetailView(title: "Wind Speed", value: day.wind_speed.msToSystemFormat(), titleFontSize: 25, valueFontSize: 32)
                SmallItemDetailView(title: "Pressure", value: day.pressure.stringRound() + " hPA", titleFontSize: 25, valueFontSize: 32).padding(.trailing)
            }.padding(.bottom)
        }
    }
}

struct DailyCellItem: View {
    
    var day: Daily
    var time: String
    
    @State var showingDetails: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(day.weather.first!.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(15)
                    
                    Text(time)
                        .font(Font.custom("AvenirNext-Medium", size: 32))
                        .minimumScaleFactor(0.5)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Text(day.temp.max.kelvinToSystemFormat() + "   " + day.temp.min.kelvinToSystemFormat())
                            .font(Font.custom("AvenirNext-Bold", size: 30))
                            .foregroundColor(Color.white)
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(Color.white)
                    }
                }.padding()
                
                if showingDetails {
                    DailyDetailedCellItem(day: day)
                    .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .opacity), removal: AnyTransition.opacity.combined(with: .opacity)))
                }
            }
            
        }.background(Color.white.opacity(0.15)).cornerRadius(20).onTapGesture {
            withAnimation {
                self.showingDetails.toggle()
            }
        }
        
    }
}

struct DailyView: View {
    
    var daily: [Daily]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<daily.count) { i in
                let day = daily[i]
                DailyCellItem(day: day, time: (i == 0) ? "Now" : day.dt.date(.day))
            }
        }.padding(.leading).padding(.trailing)
    }
}


struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        iPadMainView(weatherModel: Mocks.mock(), location: "San Jose, CA").previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
