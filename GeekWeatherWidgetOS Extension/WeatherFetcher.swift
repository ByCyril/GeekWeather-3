//
//  WeatherFetcher.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation
import SwiftUI
import GWFoundation
import CoreLocation

final class WeatherFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weatherModel: [WeatherModel] = []
    @Published var fetchError: Bool = false
    
    func fetchWeater() {
        
    }
}
