//
//  LocationManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var notificationManager = NotificationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        authorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus(status, manager)
    }
    
    func authorizationStatus(_ status: CLAuthorizationStatus = CLLocationManager.authorizationStatus(),
                             _ manager: CLLocationManager = CLLocationManager()) {
        
        switch status {
        case .authorizedAlways:
            authorizationEnabled(manager)
        case .authorizedWhenInUse:
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
        guard let cllocation = manager.location else { return }
        let location = Location(location: cllocation)
        let data: [AnyHashable: Any] = [Observe.data.location: location]
        notificationManager.post(data: data, to: Observe.data.location)
    }
    
    private func denied() {
        let data: [AnyHashable: Any] = ["error": "Permission Denied"]
        notificationManager.post(data: data, to: Observe.state.locationPermissionDenied)
    }
    
    private func notDetermined() {
        locationManager.requestLocation()
    }
    
    private func restricted() {
        
    }
    
}
