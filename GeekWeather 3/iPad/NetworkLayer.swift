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

final class NetworkLayer: NetworkManagerDelegate, LocationManagerDelegate {
    
    private var locationManager: LocationManager?
    private var networkManager: NetworkManager?
    
    weak var delegate: NetworkLayerDelegate?
    
    init() {
        networkManager = NetworkManager(self)
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
    }
    
    func fetch(_ completion: (WeatherModel, String) -> Void) {
        
    }
  
    func didFinishFetching(_ weatherModel: WeatherModel) {
        
        DispatchQueue.main.async { [weak self] in
            
        }
    }
  
    func currentLocation(_ location: CLLocation) {
        locationManager?.lookupCurrentLocation(location)
        let url = RequestURL(location: location)
        networkManager?.fetch(url)
    }
    
    func networkError(_ error: Error?) {
        
    }
    
    func locationError(_ errorMsg: String, _ status: CLAuthorizationStatus?) {
       
    }
}
