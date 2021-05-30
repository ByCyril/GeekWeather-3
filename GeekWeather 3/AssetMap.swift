//
//  AssetMap.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 5/29/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation

final class AssetMap {
    static let shared = AssetMap()
    
    private let dict: [String: String] = [
        "10n": "rain",
        "04n": "rain",
        "09d": "night-rain",
        "09n": "night-rain",
        "01n": "clouds",
        "01d": "sun",
        "02n": "clouds",
        "02d": "cloud",
        "03d": "clouds",
        "04d": "clouds",
        "03n": "clouds",
        "10d": "rain",
        "11d": "storm",
        "11n": "storm",
        "13d": "snowflake",
        "13n": "snowflake",
        "50d": "mist",
        "50n": "mist",
    ]
    
    func animation(_ code: String) -> String {
        return dict[code] ?? ""
    }
}
