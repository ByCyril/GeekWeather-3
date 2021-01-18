//
//  GeekWeatherWidgetbundle.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/16/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

@main
struct GeekWeatherWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        GeekWeatherSmallWidget()
        GeekWeatherLargeLabeledWidget()
        GeekWeatherSmallDetailedWidget()
        GeekWeatherDetailedTodayWidget()
        MediumBundles().body
    }
    
}

struct MediumBundles: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        GeekWeatherMediumDetailedWidget()
        GeekWeatherMediumSimpleWidget()
    }
}
