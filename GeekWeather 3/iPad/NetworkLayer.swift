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
}

final class NetworkLayer {

    private let networkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    
    weak var delegate: NetworkLayerDelegate?
    
    init() {
        locationManager.startUpdatingLocation()
    }
   
    func fetch() {
        let status = locationManager.authorizationStatus
        
        switch status {
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
    
    func authorizationEnabled() {
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            reverseGeoCode(cllocation)
        } else {
            guard let location = locationManager.location else {
                throwError("unable to get location")
                return
            }
            reverseGeoCode(location)
        }
    }
    
    func denied() {
        
    }
    
    func notDetermined() {
        
    }
    
    func throwError(_ error: String) {
        
    }
    
    func reverseGeoCode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemark, error) in
            guard let firstLocation = placemark?.first else { return }
            
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
                    self?.throwError(error?.localizedDescription ?? "network error")
                }
            }
        }
    }
}
