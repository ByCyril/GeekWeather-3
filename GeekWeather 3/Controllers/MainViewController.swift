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

class MainViewController: BaseViewController {
    
    private var collectionView: UICollectionView?
    private var views: [BaseView]?
    
    private let levelOneView = LevelOneView()
    private let levelTwoView = LevelTwoView()
    private let levelThreeView = LevelThreeView()
    
    private var networkManager: NetworkManager?
    private var locationManager: LocationManager?
    private var notificationManager: NotificationManager?
    
    private var collectionViewDataSourceManager: CollectionViewDataSourceManager?
    private var collectionViewDelegateManager: CollectionViewDelegateManager?
    
    private let networkDelegateManager = NetworkManagerDelegateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViews()
        setupLocationManager()
        setupCollectionView()
    }
    
    private func setupLocationManager() {
        locationManager = LocationManager()
    }
    
    private func networkCall() {
        
        networkManager = NetworkManager(networkDelegateManager)
        let url = RequestURL(location: CLLocation(latitude: 37.3482, longitude: -121.8164), .imperial)
        networkManager?.fetch(url)
    }
    
    private func setupContainerViews() {
        views = [levelOneView, levelTwoView, levelThreeView]
    }
    
    private func setupCollectionView() {
        collectionViewDataSourceManager = CollectionViewDataSourceManager(views!)
        collectionViewDelegateManager = CollectionViewDelegateManager(views!)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.itemSize = view.frame.size
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView?.register(ControllerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = collectionViewDelegateManager
        collectionView?.dataSource = collectionViewDataSourceManager
        collectionView?.isPagingEnabled = true
        collectionView?.reloadData()
        
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
        
    }
    
    func didReceiveError(_ error: Error?) {
        
    }
}

extension MainViewController: LocationManagerDelegate {
    func currentLocation(_ location: CLLocation) {
        
    }
    
    func locationError(_ errorMsg: String) {
        
    }
    
        
}
