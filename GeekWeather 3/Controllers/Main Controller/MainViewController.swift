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

class MainViewController: BaseViewController, FlipperViewDataSource {

    private let flipView = FlipperView()
    
    var flipperViewArray: [BaseViewController] = [] {
        didSet {
            flipView.reload()
        }
    }
    
    private var networkManager: NetworkManager?
    private var locationManager: LocationManager?
    private var notificationManager: NotificationManager?
    
    private var collectionViewDataSourceManager: CollectionViewDataSourceManager?
    private var collectionViewDelegateManager: CollectionViewDelegateManager?
    
    private let networkDelegateManager = NetworkManagerDelegateManager()
    
    let levelOneViewController = LevelOneViewController()
    let levelTwoViewController = LevelTwoViewController()
    let levelThreeViewController = LevelThreeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flipView.dataSource = self
        view = flipView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let views = [levelOneViewController,
                     levelTwoViewController,
                     levelThreeViewController]
        
        
        for levelView in views {
            levelView.view.frame = view.bounds
            levelView.view.layoutSubviews()
        }
        
        flipperViewArray += views
    }
    
    func viewForPage(_ page: Int, flipper: FlipperView) -> UIView {
        return flipperViewArray[page].view
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
