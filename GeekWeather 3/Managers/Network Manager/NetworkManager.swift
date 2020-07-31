//
//  NetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
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
        
        let task = session.dataTask(with: param.requestUrl()) { (data, response, error) in
            if let data = data {
                do {
                    let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.notificationManager.post(data: ["currentWeather":""],
                                                       to: Observe.data.currentWeatherData)
                    }
                } catch {
                    print("error")
                }
            }
        }
        
        task.resume()
    }
    
}
