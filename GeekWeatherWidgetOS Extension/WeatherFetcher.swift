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

struct WeatherFetcherError {
    var title: String
    var description: String
}

final class WeatherFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var currentStatus: String = ""
    @Published var weatherModel: [WeatherModel] = []
    @Published var location: String = ""
    @Published var fetchError: Bool = false
    @Published var error: [WeatherFetcherError] = []
    
    private var locationManager: CLLocationManager?
    private let networkManager = NetworkManager()
    
    func fetch() {
        print("☎️ Fetching")
        currentStatus = "Fetching"
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
        let err = WeatherFetcherError(title: "Unable to get location", description: "Please try again later or try to manually search for a location. If the issue persists, please let the developer know!")
        error = [err]
    }
    
    func notDetermined() {
        print("👎🏼 not determined")
        let err = WeatherFetcherError(title: "Unable to get location", description:  "Please try again later or try to manually search for a location. If the issue persists, please let the developer know!")
        error = [err]
    }
    
    func fetch(with location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemark, error) in
            guard let firstLocation = placemark?.first else {
                let err = WeatherFetcherError(title: "Unable to get location", description: error?.localizedDescription ?? "Please try again later or try to manually search for a location. If the issue persists, please let the developer know!")
                self?.error = [err]
                return
            }
            self?.currentStatus = "Getting Location"
            let locality = firstLocation.locality ?? ""
            let administrativeArea = firstLocation.administrativeArea ?? ""
            let locationStr = "\(locality), \(administrativeArea)"
            self?.beginFetchingWeatherData(location, locationStr)
        }
    }
    
    func beginFetchingWeatherData(_ location: CLLocation,_ locationStr: String) {
        let url = RequestURL(location: location)
        print("👀 URL",url.url.absoluteString)
        currentStatus = "Getting Weather Data"
        networkManager.fetch(url) { [weak self] (weatherModel, error) in
            
            DispatchQueue.main.async { [weak self] in
                if let model = weatherModel {
                    self?.weatherModel.append(model)
                    self?.location = locationStr
                } else {
                    let err = WeatherFetcherError(title: "Network Error!", description: error?.localizedDescription ?? "Something went wrong. Please try again later. If error persist, please let the developer know!")
                    self?.error = [err]
                }
            }
        }
    }
}
