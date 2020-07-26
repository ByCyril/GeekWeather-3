//
//  GWNetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
import UIKit

enum Unit: String {
    case imperial = "units=imperial"
    case metric = "units=metric"
    case auto = ""
}

struct RequestURL {
    var base = "https://api.openweathermap.org/data/2.5/onecall"

    var location: CLLocation
    var unit: Unit
    
    var appid = "appid=79048569b8ad1fa5c026d1be99adc0cd" {
        didSet {
            appid = "appid=\(appid)"
        }
    }
    
    var exclude = "exclude=minutely" {
        didSet {
            exclude = "exclude=\(exclude)"
        }
    }
        
    func requestUrl() -> URL {
        let lon = "lon=\(location.coordinate.longitude)"
        let lat = "lat=\(location.coordinate.latitude)"
        return URL(string: "\(base)?\(lat)&\(lon)&\(appid)&\(unit.rawValue)&\(exclude)")!
    }
}

final class GWNetworkManager {
    
    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetch(_ param: RequestURL) {
        print(param.requestUrl())
        let task = session.dataTask(with: param.requestUrl()) { (data, response, error) in
            if let data = data {
                do {
                    let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                        
                } catch {
                    print("error")
                }
            }
        }
        
        task.resume()
    }
    
}
