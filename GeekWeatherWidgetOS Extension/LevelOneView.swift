//
//  LevelOneView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct LevelOneView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image(weatherModel.current.weather.first!.icon).resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                    .cornerRadius(15).padding(.top).padding(.trailing)
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(weatherModel.current.temp.kelvinToSystemFormat())
                        .font(Font.custom("AvenirNext-Bold", size: 50))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    Text("San Jose, CA").font(Font.custom("AvenirNext-Regular", size: 25))
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white).padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                }.padding(.bottom).padding(.leading)
                Spacer()
            }.padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct LevelOneView_Previews: PreviewProvider {
    static var previews: some View {
        LevelOneView()
    }
}
