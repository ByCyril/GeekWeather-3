//
//  MainPadController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import GWFoundation
import CoreLocation
import UIKit

final class MainPadController: UIViewController, NetworkManagerDelegate, LocationManagerDelegate {
 
    private var locationManager: LocationManager?
    private var networkManager: NetworkManager?

    private var layerOne = LayerOneView()
    private var layerTwo = LayerTwoView()
    
    private let myLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        createGradient()
        createLayerOne()
        createLayerTwo()
        
        view.addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.font = GWFont.AvenirNext(style: .Medium, size: 15)
        myLabel.text = "Developed and designed by Cyril © 2017 - 2021"
        myLabel.textAlignment = .center
        myLabel.adjustsFontSizeToFitWidth = true
        myLabel.minimumScaleFactor = 0.5

        NSLayoutConstraint.activate([
            myLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])

        view.layoutIfNeeded()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func createLayerOne() {
        layerOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(layerOne)
        
        NSLayoutConstraint.activate([
            layerOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            layerOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            layerOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    func createLayerTwo() {
        layerTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(layerTwo)
        
        NSLayoutConstraint.activate([
            layerTwo.topAnchor.constraint(equalTo: layerOne.bottomAnchor, constant: 35),
            layerTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            layerTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            layerTwo.heightAnchor.constraint(equalToConstant: 310)
        ])
        
        view.layoutIfNeeded()
    }
    
    func initMethod() {
        
        if let mock = Mocks.mockedResponse() {
            networkManager = NetworkManager(self, mock)
        } else {
            networkManager = NetworkManager(self)
        }
        
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
      
    }
    
    func createGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func didFinishFetching(_ weatherModel: WeatherModel) {
        
        DispatchQueue.main.async { [weak self] in
            self?.layerOne.populate(weatherModel)
            self?.layerTwo.populate(weatherModel)
        }
    }
    
    func networkError(_ error: Error?) {
        
    }
    
    func currentLocation(_ location: CLLocation) {
        locationManager?.lookupCurrentLocation(location)
        let url = RequestURL(location: location)
        networkManager?.fetch(url)
    }
    
    func locationError(_ errorMsg: String, _ status: CLAuthorizationStatus?) {
       
    }
    
}
