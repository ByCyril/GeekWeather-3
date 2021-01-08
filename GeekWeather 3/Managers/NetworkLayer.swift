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
import MapKit

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
        print("🔴 New Location locationManagerDidChangeAuthorization")
        
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
   
    func fetch() {
        
        if Mocks.showMockedResponse() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.delegate?.didFinishFetching(weatherModel: Mocks.mock(), location: "Sunnyvale, CA")
            }
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func authorizationEnabled(_ manager: CLLocationManager) {
        manager.startUpdatingLocation()
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            fetch(with: cllocation)
        } else {
            guard let location = manager.location else {
                let errorDetailsDev = "Error Details for Dev:\nLocManager:\(manager)\nLoc: \(String(describing: manager.location))"
//                let errorDetails = "Could not get your current location at the moment. Please try again or let the developer know if the issue persists."
                
                delegate?.didFail(errorTitle: "Location Error",
                                  errorDetail: errorDetailsDev)
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
            
            let locality = firstLocation.locality ?? ""
            let administrativeArea = firstLocation.administrativeArea ?? ""
            let locationStr = "\(locality), \(administrativeArea)"
            self?.beginFetchingWeatherData(location, locationStr)
        }
    }
  
    func beginFetchingWeatherData(_ location: CLLocation,_ locationStr: String) {
        let url = RequestURL(location: location)
        
        networkManager.fetch(url) { [weak self] (weatherModel, error) in
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.setValue(Date(), forKey: SharedUserDefaults.Keys.LastUpdated)
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
