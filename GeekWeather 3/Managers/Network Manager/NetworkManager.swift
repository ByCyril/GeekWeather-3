//
//  NetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class NetworkManager {
    
    private var session: URLSession
    private var notificationManager: NotificationManager
    
    init(_ session: URLSession,
         _ notificationManager: NotificationManager = NotificationManager()) {
        self.session = session
        self.notificationManager = notificationManager
    }
    
    func fetch(_ param: RequestURL) {
        
        let task = session.dataTask(with: param.url) { (data, response, error) in
            if let data = data {
                do {
                    let _ = try JSONSerialization.jsonObject(with: data,
                                                             options: .mutableContainers) as? [String: AnyObject]
                    
                    DispatchQueue.main.async { [weak self] in
                        let currently = Currently(timestamp: 0.0)
                        let daily = Daily(timestamp: 0.0)
                        let hourly = Hourly(timestamp: 0.0)
                        let weatherData = Weather(currently: currently, daily: daily, hourly: hourly)
                        
                        let data: [AnyHashable: Any] = [Observe.data.response.rawValue: weatherData]
                        
                        self?.notificationManager.post(data: data,
                                                       to: Observe.data.response)
                    }
                } catch {
                    print("error")
                }
            }
        }
        
        task.resume()
    }
    
}
