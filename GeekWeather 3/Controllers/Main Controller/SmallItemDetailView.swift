//
//  SmallItemDetailView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/25/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct SmallItemDetailView: View {
    var title: String
    var value: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(Font.custom("AvenirNext-Medium", size: 25))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                Text(value)
                    .font(Font.custom("AvenirNext-Medium", size: 32))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
            }.padding(.all, 7.5)
        }.background(Color.white.opacity(0.15)).cornerRadius(15)
    }
}
