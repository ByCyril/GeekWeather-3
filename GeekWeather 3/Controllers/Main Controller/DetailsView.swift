//
//  DetailsView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/24/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct SmallItemDetailView: View {
    var title: String
    var value: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(Font.custom("AvenirNext-Medium", size: 15))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                Text(value)
                    .font(Font.custom("AvenirNext-Medium", size: 20))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
            }.padding(.all, 7.5)
        }.background(Color.white.opacity(0.15)).cornerRadius(15)
    }
}

struct DetailsView: View {
    var dismissAction: (() -> Void)
    
    var dailyModel: Daily

    var body: some View {
        
        VStack {
            HStack {
                Image(dailyModel.weather.first!.icon).resizable().frame(width: 50, height: 50, alignment: .center).padding(.trailing)
                VStack(alignment: .leading) {
                    Text(dailyModel.dt.date(.day)).font(Font.custom("AvenirNext-Medium", size: 25))
                    Text(dailyModel.weather.first!.description.capitalized).font(Font.custom("AvenirNext-Bold", size: 17))
                }
                Spacer()

                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle").resizable().frame(width: 25, height: 25, alignment: .center)
                }
            }.padding(.top).padding(.leading).padding(.trailing)
            
            VStack(alignment: .leading) {
                HStack {
                    SmallItemDetailView(title: "Sunrise", value: dailyModel.sunrise.convertTime().lowercased())
                    SmallItemDetailView(title: "Sunset", value: dailyModel.sunset.convertTime().lowercased())
                    SmallItemDetailView(title: "Chance of Rain", value: dailyModel.pop.percentage(chop: false))
                }
                HStack {
                    SmallItemDetailView(title: "Cloud Cover", value: dailyModel.clouds.percentage(chop: true))
                    SmallItemDetailView(title: "Humidity", value: dailyModel.humidity.percentage(chop: true))
                    SmallItemDetailView(title: "UV Index", value: dailyModel.uvi.stringRound())
                }
                HStack {
                    SmallItemDetailView(title: "Dew Point", value: dailyModel.dew_point.kelvinToSystemFormat())
                    SmallItemDetailView(title: "Wind Speed", value: dailyModel.wind_speed.msToSystemFormat())
                    SmallItemDetailView(title: "Pressure", value: dailyModel.pressure.stringRound() + " hPA")
                }
                
            }.padding(.bottom)
            
        }.background(LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .topLeading, endPoint: .bottomTrailing)).foregroundColor(.white).cornerRadius(25).shadow(radius: 5)
        
    }
}

struct ContainerView: View {
    var dailyModel: Daily
    var dismissAction: (() -> Void)

    @State var offset: CGFloat = 1000

    var body: some View {
        DetailsView(dismissAction: dismissAction, dailyModel: dailyModel).padding().offset(x: 0, y: self.offset).onAppear {
            withAnimation(.interactiveSpring()) {
                self.offset = 0
            }
        }
    }
}
