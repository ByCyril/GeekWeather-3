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
    
    @Published var currentStatus: String = ""
    @Published var weatherModel: [WeatherModel] = []
    @Published var location: String = ""
    @Published var fetchError: Bool = false
    @Published var error: [WeatherFetcherError] = []
    @Published var lastUpdatedStr: String = ""
    
    private var locationManager: CLLocationManager?
    private let networkManager = NetworkManager()
    
    
    func fetch() {
        print("☎️ Fetching")
        lastUpdatedStr = ""
        currentStatus = "Fetching"
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    func calculateLastUpdated() {
        
        if let lastUpdate = UserDefaults.standard.value(forKey: "LastUpdatedWatchOS") as? Date {
            let differenceInSeconds = abs(lastUpdate.timeIntervalSince(Date()))
            let minutesPassed = differenceInSeconds / 60
            
            if minutesPassed < 1 {
                lastUpdatedStr = "\(Int(differenceInSeconds)) sec ago"
            } else if minutesPassed < 60 {
                lastUpdatedStr = "\(Int(minutesPassed)) min ago"
            } else {
                fetch()
            }
        }
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
        let err = WeatherFetcherError(title: "Unable to get location", description: "You can manually set a default location to fetch weather data from inside the GeekWeather App. If the issue persists, please let the developer know!")
        error = [err]
    }
    
    func notDetermined() {
        print("👎🏼 not determined")
        let err = WeatherFetcherError(title: "Unable to get location", description: "You can manually set a default location to fetch weather data from inside the GeekWeather App. If the issue persists, please let the developer know!")
        error = [err]
    }
    
    func fetch(with location: CLLocation) {
        UserDefaults.standard.removeObject(forKey: "LastUpdatedWatchOS")
        weatherModel.removeAll()
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
                    UserDefaults.standard.setValue(Date(), forKey: "LastUpdatedWatchOS")
                    self?.weatherModel = [model]
                    self?.location = locationStr
                    self?.lastUpdatedStr = "Now"
                } else {
                    let err = WeatherFetcherError(title: "Network Error!", description: error?.localizedDescription ?? "Something went wrong. Please try again later. If error persist, please let the developer know!")
                    self?.error = [err]
                }
            }
        }
    }
}
