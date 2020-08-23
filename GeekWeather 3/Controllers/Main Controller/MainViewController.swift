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

class MainViewController: UIViewController, FlipperViewDataSource {

    private var flipperViewArray: [BaseViewController] = [] {
        didSet {
            flipView.reload()
        }
    }
    
    private var networkManager: NetworkManager?
    private var locationManager: LocationManager?
    private var notificationManager: NotificationManager?
    
    private let flipView = FlipperView()

    private let networkDelegateManager = NetworkManagerDelegateManager()
    
    private let levelOneViewController = LevelOneViewController()
    private let levelTwoViewController = LevelTwoViewController()
    private let levelThreeViewController = LevelThreeViewController()
    
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
