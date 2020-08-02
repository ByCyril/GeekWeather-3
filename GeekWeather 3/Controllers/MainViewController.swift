//
//  MainViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import NVFoundation
import CoreLocation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    private var collectionView: UICollectionView?
    private var views: [BaseView]?
    
    private var levelOneView = LevelOneView()
    private var levelTwoView = LevelTwoView()
    private var levelThreeView = LevelThreeView()
    
    private var networkManager: NetworkManager?
    private var locationManager: LocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupContainerViews()
//        setupCollectionView()
        networkCall()
    }
    
    private func networkCall() {
        
        networkManager = NetworkManager(self)
        
        let url = RequestURL(location: CLLocation(latitude: 37.3482, longitude: -121.8164), .imperial)
        print(url.url.absoluteString)
//        networkManager?.fetch(url)
    }
    
    private func setupContainerViews() {
        views = [levelOneView, levelTwoView, levelThreeView]
        collectionView?.reloadData()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.itemSize = view.frame.size
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView?.register(ControllerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let levelView = views![indexPath.row]
        levelView.animate()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ControllerViewCell else { return ControllerViewCell() }
        
        guard let views = self.views else { return ControllerViewCell() }
        
        cell.initUI(views[indexPath.row])
        
        return cell
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func didReceiveError(_ error: Error?) {
        print(error?.localizedDescription)
    }
    
    
    func didFinishFetching(_ currently: Currently, _ hourly: [Hourly], _ daily: [Daily]) {
        
    }

}
