//
//  LocationManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func currentLocation(_ location: CLLocation)
    func locationError(_ errorMsg: String,_ status: CLAuthorizationStatus?)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var notificationManager = NotificationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    init(_ delegate: LocationManagerDelegate) {
        super.init()
        locationManager.delegate = self
        self.delegate = delegate
        authorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationError(error.localizedDescription, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.currentLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus(status, manager)
    }
    
    private func authorizationStatus(_ status: CLAuthorizationStatus = CLLocationManager.authorizationStatus(),
                             _ manager: CLLocationManager = CLLocationManager()) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationEnabled(manager)
        case .denied, .restricted:
            delegate?.locationError("Location access either denied or restricted", status)
        case .notDetermined:
             notDetermined()
        @unknown default:
            notDetermined()
        }
    }
    
    private func authorizationEnabled(_ manager: CLLocationManager) {
        guard let location = manager.location else { return }
        delegate?.currentLocation(location)
    }
    
    private func notDetermined() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func coordinates() -> CLLocation {
        return locationManager.location ?? CLLocation(latitude: 37.3230, longitude: -122.0322)
    }
    
    func lookupCurrentLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if let error = error {
                self.notificationManager.post(data: ["currentLocation": error.localizedDescription],
                                              to: NotificationName.observerID("currentLocation"))
            } else {
                guard let firstLocation = placemark?.first else { return }
                
                let city = firstLocation.locality ?? ""
                
                if firstLocation.country == "United States" {
                    let state = firstLocation.administrativeArea ?? ""
                    self.notificationManager.post(data: ["currentLocation": city + ", " + state],
                                             to: NotificationName.observerID("currentLocation"))
                    return
                }
                
                self.notificationManager.post(data: ["currentLocation": city],
                                         to: NotificationName.observerID("currentLocation"))
                
            }
            
        }
    }
    
}
