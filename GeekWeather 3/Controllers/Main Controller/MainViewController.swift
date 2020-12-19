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
    
    @IBOutlet var navView: NavigationView!
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var customNavView: UIView!
    
    private var collectionViewDataSourceManager: CollectionViewDataSourceManager?
    private var collectionViewDelegateManager: CollectionViewDelegateManager?
    
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        
        let height: CGFloat = view.bounds.size.height - (100 - topPadding)
        print(height, view.bounds)
        let size = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: height)
        
        let levelOneViewController = LevelOneViewController(frame: size)
        let levelTwoViewController = LevelTwoViewController(frame: size)
        let levelThreeViewController = LevelThreeViewController(frame: size)
        
        levels = [levelOneViewController, levelTwoViewController, levelThreeViewController]
        
        collectionViewDataSourceManager = CollectionViewDataSourceManager(levels)
        collectionViewDelegateManager = CollectionViewDelegateManager(levels, CGSize(width: view.bounds.size.width, height: height))
        collectionViewDelegateManager?.vc = self
        navView.rollableTitleView.itemHeight = 75
        
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
        
    }
    
    func prepareToDeliverData(_ weatherModel: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.notificationManager.post(data: ["weatherModel": weatherModel],
                                           to: NotificationName.observerID("weatherModel"))
        }
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
