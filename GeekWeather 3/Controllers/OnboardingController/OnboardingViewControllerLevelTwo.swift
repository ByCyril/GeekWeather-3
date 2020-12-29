//
//  OnboardingViewControllerLevelTwo.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import CoreLocation

final class OnboardingViewControllerLevelTwo: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var allowButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        denyButton.layer.borderWidth = 2
        denyButton.layer.borderColor = denyButton.titleLabel?.textColor.cgColor
        denyButton.layer.cornerRadius = 10
        
        allowButton.layer.borderWidth = 2
        allowButton.layer.borderColor = allowButton.titleLabel?.textColor.cgColor
        allowButton.layer.cornerRadius = 10
        
        view.backgroundColor = UIColor(named: "White")
    }
    
    
    @IBAction func requestLocationPermission(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnboardingViewControllerLevelFour")
            show(vc, sender: self)
        }
    }
}
