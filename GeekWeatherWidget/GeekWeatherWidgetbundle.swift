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
struct GeekWeatherWidgetBundles: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        GeekWeatherSmallWidget()
        GeekWeatherLargeLabeledWidget()
        GeekWeatherSmallDetailedWidget()
    }
    
}
