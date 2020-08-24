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
    
    private let locationManager = LocationManager()
    private let notificationManager = NotificationManager()
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
        
        networkManager = NetworkManager(self)
        
        locationManager.delegate = self
        locationManager.authorizationStatus()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func viewForPage(_ page: Int, flipper: FlipperView) -> UIView {
        return flipperViewArray[page].view
    }
    
}

extension MainViewController: NetworkManagerDelegate {
    func didFinishFetching(_ weatherModel: WeatherModel) {
        notificationManager.post(data: ["weatherModel": weatherModel],
                                 to: NotificationName.observerID("weatherModel"))
    }
    
    func didReceiveError(_ error: Error?) {
        
    }
}

extension MainViewController: LocationManagerDelegate {
    func currentLocation(_ location: CLLocation) {
        locationManager.lookupCurrentLocation(location)
//        networkManager?.fetch(RequestURL(location: location, .imperial))
    }
    
    func locationError(_ errorMsg: String) {
        print(errorMsg)
    }
}
