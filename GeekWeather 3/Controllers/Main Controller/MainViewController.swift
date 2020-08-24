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

    @IBOutlet weak var flipView: FlipperView!
    
    private var flipperViewArray: [UIViewController] = [] {
        didSet {
            flipView.reload()
        }
    }
    
    private var networkManager: NetworkManager?
    private var locationManager: LocationManager?
    private var notificationManager = NotificationManager()
    
    private let networkDelegateManager = NetworkManagerDelegateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flipView.dataSource = self
        let levelOneViewController = LevelOneViewController(nibName: "LevelOneViewController", bundle: nil)
        let levelTwoViewController = LevelTwoViewController(nibName: "LevelTwoViewController", bundle: nil)
        let levelThreeViewController = LevelThreeViewController(nibName: "LevelThreeViewController", bundle: nil)
        
        let views = [levelOneViewController, levelTwoViewController, levelThreeViewController]
        
        
        for levelView in views {
            levelView.view.frame = view.bounds
            levelView.view.layoutSubviews()
        }
        
        flipperViewArray += views
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        networkManager = NetworkManager(self)
        let url = RequestURL(location: CLLocation(latitude: 37.3482, longitude: -121.8165), .imperial)
        networkManager?.fetch(url)
        
    }
    
    func viewForPage(_ page: Int, flipper: FlipperView) -> UIView {
        return flipperViewArray[page].view
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func didFinishFetching(_ weatherModel: WeatherModel) {
        notificationManager.post(data: ["weatherData": weatherModel], to: NotificationName.observerID("weatherData"))
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
