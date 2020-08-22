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
    func locationError(_ errorMsg: String)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var notificationManager = NotificationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        authorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationError(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.currentLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus(status, manager)
    }
    
    func authorizationStatus(_ status: CLAuthorizationStatus = CLLocationManager.authorizationStatus(),
                             _ manager: CLLocationManager = CLLocationManager()) {
        
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            authorizationEnabled(manager)
        case .denied:
            denied()
        case .notDetermined:
            notDetermined()
        case .restricted:
            restricted()
        @unknown default:
            notDetermined()
        }
    }
    
    private func authorizationEnabled(_ manager: CLLocationManager) {
        guard let location = manager.location else {
            
            return
        }
        delegate?.currentLocation(location)
    }
    
    private func denied() {
//        delegate?.location("Permission Denied")
        delegate?.locationError("Permission Denied")
    }
    
    private func notDetermined() {
        locationManager.requestLocation()
    }
    
    private func restricted() {
        
    }
    
}
