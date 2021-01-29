//
//  NetworkLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol NetworkLayerDelegate: AnyObject {
    func didFinishFetching(weatherModel: WeatherModel, location: String)
    func didFail(errorTitle: String, errorDetail: String)
}

final class NetworkLayer: NSObject, CLLocationManagerDelegate {
    
    private let networkManager = NetworkManager()
    var locationManager: CLLocationManager?
    
    weak var delegate: NetworkLayerDelegate?
    
    var timesTried = 0
    let cache = NSCache<NSString, WeatherClass>()
    
    override init() {
        super.init()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("####################################")
        print("🔴 New Location locationManagerDidChangeAuthorization")
        print("####################################")
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationEnabled(manager)
        case .denied, .restricted:
            denied()
        case .notDetermined:
            notDetermined()
        @unknown default:
            notDetermined()
        }
    }
    
    @objc
    func fetch() {
        
        if Mocks.showMockedResponse() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
                self?.delegate?.didFinishFetching(weatherModel: Mocks.mock(), location: "San Jose")
            }
            return
        }
        
        if let err = Mocks.mockError() {
            delegate?.didFail(errorTitle: "Error", errorDetail: err.localizedDescription)
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func fetch(_ callback: @escaping (WeatherModel?, Error?, String?) -> Void) {
        
    }
    
    func authorizationEnabled(_ manager: CLLocationManager) {
        manager.startUpdatingLocation()
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            fetch(with: cllocation)
        } else {
            guard let location = manager.location else {
                //                let errorDetails = "Could not get your current location at the moment. Please try again or let the developer know if the issue persists."
                
                
                if timesTried < 1 {
                    fetch()
                    timesTried += 1
                } else {
                    let errorDetailsDev = "Error Details for Dev:\n\nLocManager:\(manager)\nLoc: \(String(describing: manager.location))"
                    delegate?.didFail(errorTitle: "Location Error",
                                      errorDetail: errorDetailsDev)
                }
                
                return
            }
            fetch(with: location)
        }
    }
    
    func denied() {
        let key = SharedUserDefaults.Keys.DefaultLocation
        if let location = sharedUserDefaults?.value(forKey: key) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            
            fetch(with: cllocation)
        } else {
            delegate?.didFail(errorTitle: "Could not find a default location",
                              errorDetail: "You can set a default location under search.")
        }
    }
    
    func notDetermined() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func fetch(with location: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemark, error) in
            guard let firstLocation = placemark?.first else {
                self?.delegate?.didFail(errorTitle: "Unable to get location",
                                        errorDetail: error?.localizedDescription ?? "Please try again later or try to manually search for a location. If the issue persists, please let the developer know!")
                return
            }

            let locality = firstLocation.locality ?? firstLocation.subLocality ?? "Current Location"
            self?.beginFetchingWeatherData(location, locality)
        }
    }
    
    func beginFetchingWeatherData(_ location: CLLocation,_ locationStr: String) {
        let url = RequestURL(location: location)
        print("####################################")
        print("👀 URL",url.url.absoluteString)
        print("####################################")
        if let model = cache.object(forKey: url.url.absoluteString as NSString) {
            print("####################################")
            print("#### Pulling from Cache ####")
            print("####################################")
            delegate?.didFinishFetching(weatherModel: model.weatherModel, location: locationStr)
            return
        }
        
        networkManager.fetch(url) { [weak self] (weatherModel, error) in
            DispatchQueue.main.async { [weak self] in
                
                UserDefaults.standard.setValue(Date(), forKey: SharedUserDefaults.Keys.LastUpdated)
                
                if let model = weatherModel {
                    
                    if self!.cache.object(forKey: url.url.absoluteString as NSString) == nil {
                        self!.cache.setObject(WeatherClass(model), forKey: url.url.absoluteString as NSString)
                    }
                    
                    self?.delegate?.didFinishFetching(weatherModel: model, location: locationStr)
                    
                } else {
                    self?.delegate?.didFail(errorTitle: "Network Error!",
                                            errorDetail: error?.localizedDescription ?? "Something went wrong. Please try again later. If error persist, please let the developer know!")
                }
            }
        }
    }
    
    func validate(_ key: String,_ completion: @escaping (String?) -> Void) {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?appid=\(key)")!
        URLSession(configuration: config).dataTask(with: url) { (_, response, error) in
            if let res = response as? HTTPURLResponse {
                if res.statusCode == 400 {
                    completion(nil)
                    return
                }
            }
            
            completion(error?.localizedDescription ?? "Something went wrong. Please try again later. If the error persists, please let the developer know!")
            
        }.resume()
    }
}
