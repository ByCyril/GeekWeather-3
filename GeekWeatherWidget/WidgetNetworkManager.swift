//
//  WidgetNetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation


extension LocationParam {
    convenience init(location: CLLocation) {
        self.init(identifier: "", display: "")
    }
}

final class WidgetNetworkManager: NSObject, CLLocationManagerDelegate {
    
    var session: URLSession?
    var location: CLLocationManager?
    var networkManager = NetworkManager()
    
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
        
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.WidgetDefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"]  as! CLLocationDegrees)
            
            let url = RequestURL(location: cllocation)
            
            session?.dataTaskWithUrl(url, completion: { (data, response, error) in
                
                if let error = error {
                    completion(nil, error, error.localizedDescription)
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                        
                        let model = self.networkManager.formatData(response: weatherModel)
                        
                        completion(model,nil, location["name"] as? String ?? "na")
                        
                    } catch {
                        completion(nil,error,nil)
                    }
                }
                
            }).resume()
            return
        }
        
        if let location = location?.location {
            
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
                        let model = self.networkManager.formatData(response: weatherModel)

                        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                            guard let firstLocation = placemark?.first else { return }
                            
                            if firstLocation.country == "United States" {
                                let state = firstLocation.administrativeArea ?? ""
                                completion(model,nil, "\(firstLocation.locality!), \(state)")
                                return
                            }
                            
                            completion(model,nil,firstLocation.locality!)
                        }
                        
                    } catch {
                        completion(nil,error,nil)
                    }
                }
                
            }).resume()
        }
    }
    
}
