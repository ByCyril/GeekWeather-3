//
//  DetailsView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/24/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    var dismissAction: (() -> Void)
    
    var dailyModel: Daily

    var body: some View {
        
        VStack {
            HStack {
                Image(dailyModel.weather.first!.icon)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(.trailing)
                    .accessibility(label: Text("Icon"))
                    .accessibility(value: Text(dailyModel.weather.first!.main))
                
                VStack(alignment: .leading) {
                    Text(dailyModel.dt.date(.day)).font(Font.custom("AvenirNext-Medium", size: 25)).accessibility(hidden: true)
                    Text(dailyModel.weather.first!.description.capitalized).font(Font.custom("AvenirNext-Bold", size: 17)).accessibility(hidden: true)
                }.accessibility(label: Text("Header")).accessibilityElement(children: .combine).accessibility(value: Text("\(dailyModel.dt.date(.day)), \(dailyModel.weather.first!.description)"))
                Spacer()

                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle.fill").resizable().frame(width: 25, height: 25, alignment: .center)
                }.accessibility(label: Text("Dismiss Button"))
                
            }.padding(.top).padding(.leading).padding(.trailing)
            
            VStack(alignment: .leading) {
                HStack {
                    SmallItemDetailView(title: "Sunrise", value: dailyModel.sunrise.convertTime().lowercased(), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "Sunset", value: dailyModel.sunset.convertTime().lowercased(), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "Chance of Rain", value: dailyModel.pop.percentage(chop: false), titleFontSize: 15, valueFontSize: 20)
                }
                HStack {
                    SmallItemDetailView(title: "Cloud Cover", value: dailyModel.clouds.percentage(chop: true), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "Humidity", value: dailyModel.humidity.percentage(chop: true), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "UV Index", value: dailyModel.uvi.stringRound(), titleFontSize: 15, valueFontSize: 20)
                }
                HStack {
                    SmallItemDetailView(title: "Dew Point", value: dailyModel.dew_point.kelvinToSystemFormat(), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "Wind Speed", value: dailyModel.wind_speed.msToSystemFormat(), titleFontSize: 15, valueFontSize: 20)
                    SmallItemDetailView(title: "Pressure", value: dailyModel.pressure.stringRound() + " hPA", titleFontSize: 15, valueFontSize: 20)
                }
                
            }.padding()
            
        }.background(Color("demo-background")).foregroundColor(.white).cornerRadius(25).shadow(radius: 5)
        
    }
}

struct ContainerView: View {
    var dailyModel: Daily
    var dismissAction: (() -> Void)
    
    var body: some View {
        DetailsView(dismissAction: dismissAction, dailyModel: dailyModel).padding()
    }
}
