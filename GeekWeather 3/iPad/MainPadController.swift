//
//  MainPadController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import CoreLocation
import SwiftUI

final class MainPadController: UIViewController, NetworkManagerDelegate, LocationManagerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    private var locationManager: LocationManager?
    private var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(self)
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
    }
 
    func didFinishFetching(_ weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            let swiftUIView = iPadMainView(weatherModel: weatherModel)
            let viewCtrl = UIHostingController(rootView: swiftUIView)
            
            UIApplication.shared.windows.first?.rootViewController = viewCtrl
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func networkError(_ error: Error?) {
        
    }
    
    func currentLocation(_ location: CLLocation) {
        let url = RequestURL(location: location)
        networkManager?.fetch(url)
    }
    
    func locationError(_ errorMsg: String, _ status: CLAuthorizationStatus?) {
        
    }
    
}
