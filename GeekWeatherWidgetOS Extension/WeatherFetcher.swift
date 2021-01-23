//
//  WeatherFetcher.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation
import SwiftUI
import GWFoundation
import CoreLocation

final class WeatherFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weatherModel: [WeatherModel] = []
    @Published var fetchError: Bool = false
    
    private var locationManager: CLLocationManager?
    private let networkManager = NetworkManager()
    
    func fetch() {
        print("☎️ Fetching")
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
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
    
    func authorizationEnabled(_ manager: CLLocationManager) {
        print("👍🏼 Location Enabled")
        manager.startUpdatingLocation()
        
        guard let location = manager.location else { return }
        fetch(with: location)
    }
    
    func denied() {
        print("👎🏼 denied")
    }
    
    func notDetermined() {
        print("👎🏼 not determined")
    }
    
    func fetch(with location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemark, error) in
            guard let firstLocation = placemark?.first else {
//                self?.delegate?.didFail(errorTitle: "Unable to get location",
//                                        errorDetail: error?.localizedDescription ?? "Please try again later or try to manually search for a location. If the issue persists, please let the developer know!")
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
        print("👀 URL",url.url.absoluteString)
        networkManager.fetch(url) { [weak self] (weatherModel, error) in
            DispatchQueue.main.async { [weak self] in
//                UserDefaults.standard.setValue(Date(), forKey: SharedUserDefaults.Keys.LastUpdated)
                if let model = weatherModel {
                    self?.weatherModel.append(model)
                }
            }
        }
    }
}
