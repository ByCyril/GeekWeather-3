//
//  MainViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import CoreLocation

class MainViewController: UIViewController {
    
    private var networkManager: NetworkManager?
    
    private let locationManager = LocationManager()
    private let notificationManager = NotificationManager()
    private let networkDelegateManager = NetworkManagerDelegateManager()
    
    private var levels = [BaseView]()
    
    @IBOutlet var collectionView: UICollectionView?
    
    private var collectionViewDataSourceManager: CollectionViewDataSourceManager?
    private var collectionViewDelegateManager: CollectionViewDelegateManager?
    
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let levelOneViewController = LevelOneViewController(frame: view.bounds)
        let levelTwoViewController = LevelTwoViewController(frame: view.bounds)
        let levelThreeViewController = LevelThreeViewController(frame: view.bounds)
        
        levels = [levelOneViewController, levelTwoViewController, levelThreeViewController]
        
        collectionViewDataSourceManager = CollectionViewDataSourceManager(levels)
        collectionViewDelegateManager = CollectionViewDelegateManager(levels, view.bounds.size)
        
        collectionView?.delegate = collectionViewDelegateManager
        collectionView?.dataSource = collectionViewDataSourceManager
        
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = .clear
        collectionView?.showsVerticalScrollIndicator = false
        
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
        
    }
    
    @IBAction func presentSavedLocationController() {
        GWTransition.present(SavedLocationViewController(), from: self)
    }
    
    @IBAction func presentSettingsController() {
        GWTransition.present(SettingsController(), from: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }

        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func didFinishFetching(_ weatherModel: WeatherModel) {
        let location = CLLocation(latitude: weatherModel.lat, longitude: weatherModel.lon)
        locationManager.lookupCurrentLocation(location)
        
        DispatchQueue.main.async { [weak self] in
            self?.notificationManager.post(data: ["weatherModel": weatherModel],
                                           to: NotificationName.observerID("weatherModel"))
        }
        
    }
    
    func networkError(_ error: Error?) {
        
    }
}

extension MainViewController: LocationManagerDelegate {
    func currentLocation(_ location: CLLocation) {
        let req = RequestURL(location: location, .imperial)
        networkManager?.fetch(req)
    }
    
    func locationError(_ errorMsg: String) {
        print(errorMsg)
    }
}
