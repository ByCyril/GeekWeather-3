//
//  Weather.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

public class WeatherClass {
    let weatherModel: WeatherModel
    init(_ weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
}

public struct WeatherModel: Decodable, Encodable, Hashable {
    public var lat: Double
    public var lon: Double
    public var timezone: String
    public var timezone_offset: Double
    
    public var current: Currently
    public var hourly: [Hourly]
    public var daily: [Daily]
    
    public var alerts: [Alert]?
}

public struct Weather: Decodable, Encodable, Hashable {
    public var id: Int
    public var main: String
    public var description: String
    public var icon: String
}

public struct Currently: Decodable, Encodable, Hashable {
    public var dt: TimeInterval
    public var sunrise: TimeInterval
    public var sunset: TimeInterval
    public var temp: Double
    public var feels_like: Double
    public var pressure: Double
    public var humidity: Double
    public var dew_point: Double
    public var uvi: Double
    public var clouds: Double
    public var visibility: Double
    public var wind_speed: Double
    public var wind_deg: Double
    public var weather: [Weather]
}

public struct Temperature: Decodable, Encodable, Hashable {
    public var day: Double
    public var min: Double
    public var max: Double
    public var night: Double
    public var eve: Double
    public var morn: Double
}

public struct FeelsLikeModel: Decodable, Encodable, Hashable {
    public var day: Double
    public var night: Double
    public var eve: Double
    public var morn: Double
}

public struct Daily: Decodable, Encodable, Hashable {
    public var dt: TimeInterval
    public var sunrise: TimeInterval
    public var sunset: TimeInterval
    public var temp: Temperature
    public var feels_like: FeelsLikeModel
    
    public var pressure: Double
    public var humidity: Double
    public var dew_point: Double
    public var wind_speed: Double
    public var wind_deg: Double
    public var weather: [Weather]
    public var pop: Double
    public var clouds: Double
    public var uvi: Double
}

public struct Hourly: Decodable, Encodable, Hashable {
    public var dt: TimeInterval
    public var temp: Double
    public var feels_like: Double
    public var pressure: Double
    public var humidity: Double
    public var dew_point: Double
    public var clouds: Double
    public var visibility: Double
    public var wind_speed: Double
    public var wind_deg: Double
    public var pop: Double
    public var weather: [Weather]
}

public struct Alert: Decodable, Encodable, Hashable {
    public var sender_name: String
    public var event: String
    public var start: TimeInterval
    public var end: TimeInterval
    public var description: String
}
