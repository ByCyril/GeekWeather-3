//
//  GeekWeather_Widget.swift
//  GeekWeather-Widget
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import WidgetKit
import SwiftUI
import GWFoundation

struct WeatherEntry: TimelineEntry {
    let date: Date
    let currently: Currently
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        let data = parseSnapshot()!
        let weatherData = try! JSONDecoder().decode(WeatherModel.self, from: data)
        let entry = WeatherEntry(date: Date(), currently: weatherData.current)
        return entry
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        guard let data = parseSnapshot() else { return }
        guard let weatherData = try? JSONDecoder().decode(WeatherModel.self, from: data) else { return }
        let entry = WeatherEntry(date: Date(), currently: weatherData.current)
        
        completion(entry)
    }
 
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        guard let data = parseSnapshot() else { return }
        guard let weatherData = try? JSONDecoder().decode(WeatherModel.self, from: data) else { return }
        let entry = WeatherEntry(date: Date(), currently: weatherData.current)
        
        let x = Calendar.current.date(byAdding: .minute, value: 60, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(x))
        
        
        print(timeline,"Timeline refresh")
        completion(timeline)
    }
  
    func parseSnapshot() -> Data? {
        guard let file = Bundle.main.path(forResource: "demo", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: file)
        let data = try? Data(contentsOf: url, options: .mappedIfSafe)
        return data
    }
}

@available(iOS 14.0, *)
struct WidgetEntryView: View {
    let entry: Provider.Entry

    var body: some View {
        return ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: 0xF4B100),
                                                       Color(hex: 0xFD6B00)]),
                           startPoint: .top,
                           endPoint: .bottom)
            
            VStack {
                Spacer()
                Text("Cupertino").padding(.bottom).font(Font.custom("HelveticaNeue-Bold", size: 17, relativeTo: .subheadline)).foregroundColor(.white)
                Text(entry.currently.temp.temp()).font(Font.custom("HelveticaNeue-CondensedBold", size: 45, relativeTo: .title)).foregroundColor(.white)
                Text(entry.currently.weather.first!.main).padding(.top).font(Font.custom("HelveticaNeue-Bold", size: 15, relativeTo: .subheadline)).foregroundColor(.white)
                Spacer()
            }
        }
      
    }
}

@available(iOS 14.0, *)
@main
struct MainWidget: Widget {
    private let kind = "GeekWeather-Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { (entry) in
            WidgetEntryView(entry: entry)
        }
    }
}
extension Color {
    init(hex: Int) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
