//
//  TodayViewTimelineProvider.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/23/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import WidgetKit
import GWFoundation
import CoreLocation

struct TodayViewTimelineProvider: TimelineProvider {
        
    func placeholder(in context: Context) -> TodayViewEntry {
        return TodayViewEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TodayViewEntry) -> Void) {
        if context.isPreview {
            completion(TodayViewEntry.placeholder)
        } else {
            fetchWeatherData { (results) in
                switch results {
                case .success(let entry):
                    completion(entry)
                case .failure(_):
                    completion(TodayViewEntry.placeholder)
                }
            }
        }
    }
    
    private func fetchWeatherData(completion: @escaping (Result<TodayViewEntry, Error>) -> ()) {
        let loc = CLLocation(latitude: 37.348340, longitude: -121.816530)
        let url = RequestURL(location: loc, .imperial)
        print("URL", url)
        
        
        NetworkManager().fetch(url, { (data, error) in
            if let data = data {
                let widgetModel = WidgetWeatherModel(location: "San Jose, CA", temp: data.current.temp.temp(), icon: data.current.weather[0].icon, lastUpdated: "Relevant as of " + Date().timeIntervalSince1970.date(.time))
                let entry = TodayViewEntry(date: Date(), weatherModel: widgetModel)
                print(data)
                completion(.success(entry))
            } else {
                print("no data")
                if let error = error {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayViewEntry>) -> Void) {
        fetchWeatherData { (result) in
            switch result {
            case .success(let entry):
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 15)))
                completion(timeline)
            case .failure(_):
                let timeline = Timeline(entries: [TodayViewEntry.placeholder], policy: .after(Date().addingTimeInterval(60 * 2)))
                completion(timeline)
            }
            
        }
    }
    
    typealias Entry = TodayViewEntry
}

