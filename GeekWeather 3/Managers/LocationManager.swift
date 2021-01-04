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
        locationManager.startUpdatingLocation()
        self.delegate = delegate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationError(error.localizedDescription, nil)
    }

    func beginFetchingLocation() {
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationEnabled(locationManager)
        case .denied, .restricted:
            if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
                let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                            longitude: location["lon"] as! CLLocationDegrees)
                delegate?.currentLocation(cllocation)
            } else {
                delegate?.locationError("Location access either denied or restricted", status)
            }
        case .notDetermined:
            notDetermined()
        @unknown default:
            notDetermined()
        }
    }
    
    private func authorizationEnabled(_ manager: CLLocationManager) {
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            delegate?.currentLocation(cllocation)
        } else {
            guard let location = manager.location else {
                delegate?.locationError("unable to get location", .none)
                return
            }
            delegate?.currentLocation(location)
        }
    }
    
    private func notDetermined() {
        if let location = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            let cllocation = CLLocation(latitude: location["lat"] as! CLLocationDegrees,
                                        longitude: location["lon"] as! CLLocationDegrees)
            delegate?.currentLocation(cllocation)
        } else {
            delegate?.locationError("here", .none)
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func lookupCurrentLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            
            if let error = error {
                self.notificationManager.post(data: ["currentLocation": error.localizedDescription],
                                              to: NotificationName.observerID("currentLocation"))
            } else {
                guard let firstLocation = placemark?.first else { return }
                
                let city = firstLocation.locality ?? ""
                let country = firstLocation.country ?? ""
                print("📍 Location manager",city, country)
                if country == "United States" {
                    let state = firstLocation.administrativeArea ?? ""
                    self.notificationManager.post(data: ["currentLocation": city + ", " + state],
                                                  to: NotificationName.observerID("currentLocation"))
                    return
                }
                self.notificationManager.post(data: ["currentLocation": city + ", " + country],
                                              to: NotificationName.observerID("currentLocation"))
                
            }
            
        }
    }
    
}
