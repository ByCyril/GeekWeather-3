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
    
    private var levels = [BaseViewController]()
    
    private var collectionView: UICollectionView?
    
    private var collectionViewDataSourceManager: CollectionViewDataSourceManager?
    private var collectionViewDelegateManager: CollectionViewDelegateManager?
    
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.init(rgb: 0xF4B100).cgColor, UIColor.init(rgb: 0xFD6B00).cgColor]
//        gradientLayer.colors = [UIColor.init(rgb: 0x307ECD).cgColor, UIColor.init(rgb: 0x3344A0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
        
        if let data = FeatureFlag.mockedResponse() {
            networkManager = NetworkManager(self, data)
        } else {
            networkManager = NetworkManager(self)
        }

        locationManager.delegate = self
        
    }
    
    
    private func setupCollectionView() {
        let levelOneViewController = LevelOneViewController(nibName: "LevelOneViewController", bundle: nil)
        let levelTwoViewController = LevelTwoViewController(nibName: "LevelTwoViewController", bundle: nil)
        let levelThreeViewController = LevelThreeViewController(nibName: "LevelThreeViewController", bundle: nil)
        
        levels = [levelOneViewController, levelTwoViewController, levelThreeViewController]
        
        collectionViewDataSourceManager = CollectionViewDataSourceManager(levels)
        collectionViewDelegateManager = CollectionViewDelegateManager(levels)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.itemSize = view.frame.size
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView?.register(MainViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = collectionViewDelegateManager
        collectionView?.dataSource = collectionViewDataSourceManager
        collectionView?.isPagingEnabled = true
        collectionView?.reloadData()
        collectionView?.backgroundColor = .clear
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.layoutIfNeeded()
        
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func didFinishFetching(_ weatherModel: WeatherModel) {
        locationManager.lookupCurrentLocation(CLLocation(latitude: weatherModel.lat, longitude: weatherModel.lon))
        notificationManager.post(data: ["weatherModel": weatherModel],
                                 to: NotificationName.observerID("weatherModel"))
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
