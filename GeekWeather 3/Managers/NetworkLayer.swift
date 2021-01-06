//
//  NetworkLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/4/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation
import CoreLocation
import GWFoundation

protocol NetworkLayerDelegate: AnyObject {
    func didFinishFetching(weatherModel: WeatherModel, location: String)
    func didFail(errorTitle: String, errorDetail: String)
}

final class NetworkLayer: NSObject, CLLocationManagerDelegate {

    private let networkManager = NetworkManager()
    private var locationManager: CLLocationManager?
    
    weak var delegate: NetworkLayerDelegate?
    
    override init() {
        super.init()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            
            authorizationEnabled()
        case .denied, .restricted:
            denied()
        case .notDetermined:
            notDetermined()
        @unknown default:
            notDetermined()
        }
    }
   
    func fetch(_ mock: Data? = nil) {
        if let mock = mock {
            let response = try! JSONDecoder().decode(WeatherModel.self, from: mock)
            delegate?.didFinishFetching(weatherModel: response, location: "Sunnyvale, CA")
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func authorizationEnabled() {
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            fetch(with: cllocation)
        } else {
            locationManager?.startUpdatingLocation()
            guard let location = locationManager?.location else {
                delegate?.didFail(errorTitle: "Location Error",
                                  errorDetail: "Could not get your current location at the moment. Please try again or let the developer know if the issue persists.")
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
                self?.delegate?.didFail(errorTitle: "Unable to get location.",
                                        errorDetail: error?.localizedDescription ?? "Please try again later or try searching for a location.")
                return
            }
            
            let country = firstLocation.country ?? ""
            
            var locationStr = ""
            
            if country == "United States" {
                let locality = firstLocation.locality ?? ""
                let state = firstLocation.administrativeArea ?? ""
                locationStr = "\(locality), \(state)"
            } else {
                let locality = firstLocation.locality ?? ""
                let subLocality = firstLocation.administrativeArea ?? ""
                locationStr = "\(locality), \(subLocality)"
            }
            
            print("📍 Location manager", locationStr)
            
            self?.beginFetchingWeatherData(location, locationStr)
        }
    }
  
    func beginFetchingWeatherData(_ location: CLLocation,_ locationStr: String) {
        let url = RequestURL(location: location)
        
        networkManager.fetch(url) { [weak self] (weatherModel, error) in
            DispatchQueue.main.async { [weak self] in
                if let model = weatherModel {
                        self?.delegate?.didFinishFetching(weatherModel: model, location: locationStr)
                } else {
                    self?.delegate?.didFail(errorTitle: "Network Error",
                                            errorDetail: error?.localizedDescription ?? "Something went wrong. Please try again later. If error persist, please let the developer know!")
                }
            }
        }
    }
}
