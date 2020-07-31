//
//  LocationManagerAuthorizationStatus.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
import Foundation

class LocationManagerAuthorizationStatus: NSObject {
    
    func authorizationStatus(_ status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()) {
        
        switch status {
        case .authorizedAlways:
            authorizationAlways()
        case .authorizedWhenInUse:
            authorizationWhenInUse()
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
    
    private func authorizationAlways() {
        
    }
    
    private func authorizationWhenInUse() {
        
    }
    
    private func denied() {
        
    }
    
    private func notDetermined() {
        
    }
    
    private func restricted() {
        
    }
}
