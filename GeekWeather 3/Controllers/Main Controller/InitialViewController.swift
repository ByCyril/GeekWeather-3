//
//  InitialViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/17/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import CoreLocation
import GWFoundation
import UIKit

final class InitialViewController: UIViewController, NetworkManagerDelegate, LocationManagerDelegate {
 
    private var networkManager: NetworkManager?
    
    private var locationManager = LocationManager()
    private var mainViewController = MainViewController()
    
    private let gradientLayer = CAGradientLayer()
    private let loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
        
        if let data = FeatureFlag.mockedResponse() {
            networkManager = NetworkManager(self, data)
        } else {
            networkManager = NetworkManager(self)
        }

        locationManager.delegate = self
        
        perform(#selector(displayLoadingView), with: nil, afterDelay: 5.0)
    }
    
    @objc
    func displayLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        let size: CGFloat = 250
        
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: size),
            loadingView.heightAnchor.constraint(equalToConstant: size),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingView.removeFromSuperview()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }

        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
    }
    
    func currentLocation(_ location: CLLocation) {
        let req = RequestURL(location: location, .imperial)
        networkManager?.fetch(req)
    }
    
    func locationError(_ errorMsg: String) {
        
    }
    
    func didFinishFetching(_ weatherModel: WeatherModel) {
        let location = CLLocation(latitude: weatherModel.lat, longitude: weatherModel.lon)
        locationManager.lookupCurrentLocation(location)
        
        DispatchQueue.main.async { [weak self] in
            guard let vc = self?.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }
            
            vc.prepareToDeliverData(weatherModel)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    func networkError(_ error: Error?) {
        
    }
    
  
}
