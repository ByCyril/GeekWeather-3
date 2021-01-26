//
//  DetailsView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/25/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import GWFoundation

struct DetailsView: View {

    var daily: Daily
    
    var body: some View {
        VStack {
            Text(daily.dt.date(.day))
        }
    }
}
