//
//  TodayViewTimelineProvider.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import WidgetKit

import CoreLocation

class TodayViewTimelineProvider: TimelineProvider {

    typealias Entry = WeatherEntry
    
    func placeholder(in context: Context) -> WeatherEntry {
        guard let file = Bundle.main.path(forResource: "preview", ofType: "json") else { return WeatherEntry.placeholder }
        let url = URL(fileURLWithPath: file)

        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let response = try JSONDecoder().decode(WeatherModel.self, from: data)
            
            let model = WidgetWeatherModel(location: "San Jose, CA",
                                           temp: response.current.temp.kelvinToSystemFormat(),
                                           icon: response.current.weather[0].icon,
                                           lastUpdated: "Last Updated: " + Date().timeIntervalSince1970.convertTime(),
                                           feelsLike: "Feels like " + response.current.feels_like.kelvinToSystemFormat(),
                                           summary: response.current.weather[0].description.capitalized,
                                           currently: response.current,
                                           hourly: response.hourly,
                                           daily: response.daily)
            
            let entry = WeatherEntry(date: Date(), weatherModel: model)
            return entry
        } catch {
            return WeatherEntry.placeholder
        }
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        if context.isPreview {
            guard let file = Bundle.main.path(forResource: "preview", ofType: "json") else { return }
            let url = URL(fileURLWithPath: file)

            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let response = try JSONDecoder().decode(WeatherModel.self, from: data)
                
                let model = WidgetWeatherModel(location: "San Jose, CA",
                                               temp: response.current.temp.kelvinToSystemFormat(),
                                               icon: response.current.weather[0].icon,
                                               lastUpdated: "Last Updated: " + Date().timeIntervalSince1970.convertTime(),
                                               feelsLike: "Feels like " + response.current.feels_like.kelvinToSystemFormat(),
                                               summary: response.current.weather[0].description.capitalized,
                                               currently: response.current,
                                               hourly: response.hourly,
                                               daily: response.daily)
                
                let entry = WeatherEntry(date: Date(), weatherModel: model)
                
                completion(entry)
            } catch {
                completion(WeatherEntry.placeholder)
            }
            
        } else {
            fetchWeatherData { (results) in
                switch results {
                case .success(let entry):
                    completion(entry)
                case .failure(_):
                    completion(WeatherEntry.placeholder)
                }
            }
        }
    }
    
    private func fetchWeatherData(completion: @escaping (Result<WeatherEntry, Error>) -> ()) {
        
        WidgetNetworkManager().fetch { (model, error, city) in
            
            if let data = model, let city = city {
                let model = WidgetWeatherModel(location: city,
                                               temp: data.current.temp.kelvinToSystemFormat(),
                                               icon: data.current.weather[0].icon,
                                               lastUpdated: "Last Updated: " + Date().timeIntervalSince1970.convertTime(),
                                               feelsLike: "Feels like " + data.current.feels_like.kelvinToSystemFormat(),
                                               summary: data.current.weather[0].description.capitalized,
                                               currently: data.current,
                                               hourly: data.hourly,
                                               daily: data.daily)
                
                let entry = WeatherEntry(date: Date(), weatherModel: model)
                sharedUserDefaults?.setValue(Date(), forKey: SharedUserDefaults.Keys.WidgetLastUpdated)
                completion(.success(entry))
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        fetchWeatherData { (result) in
            switch result {
            case .success(let entry):
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 10)))
                completion(timeline)
            case .failure(_):
                let timeline = Timeline(entries: [WeatherEntry.placeholder], policy: .after(Date().addingTimeInterval(60 * 2)))
                completion(timeline)
            }
            
        }
    }
    
}
