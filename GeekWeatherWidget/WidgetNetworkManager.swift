//
//  WidgetNetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation
import GWFoundation

final class WidgetNetworkManager: NSObject, CLLocationManagerDelegate {
    
    var session: URLSession?
    var location: CLLocationManager?
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        
        session = URLSession(configuration: config)
        location = CLLocationManager()
        location?.requestWhenInUseAuthorization()
        location?.startUpdatingLocation()
        location?.delegate = self
    }
    
    public func fetch(_ completion: @escaping (WeatherModel?, Error?, String?) -> Void) {
        guard let location = location?.location else { return }
        
        let url = RequestURL(location: location)
        session?.dataTaskWithUrl(url, completion: { (data, response, error) in
            
            if let error = error {
                completion(nil, error, error.localizedDescription)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()

                do {
                    let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                    
                    CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                        guard let firstLocation = placemark?.first else { return }

                        if firstLocation.country == "United States" {
                            let state = firstLocation.administrativeArea ?? ""
                            completion(weatherModel,nil, "\(firstLocation.locality!), \(state)")
                            return
                        }

                        completion(weatherModel,nil,firstLocation.locality!)
                    }
                    
                } catch {
                    completion(nil,error,nil)
                }
            }
            
        }).resume()
        
    }
    
}
