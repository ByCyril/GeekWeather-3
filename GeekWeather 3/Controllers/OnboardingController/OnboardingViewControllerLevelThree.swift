//
//  OnboardingViewControllerLevelThree.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import CoreLocation

final class OnboardingViewControllerLevelThree: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.borderWidth = 2
        searchButton.layer.borderColor = searchButton.titleLabel?.textColor.cgColor
        searchButton.layer.cornerRadius = 10
   
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(searchedResults),
                                               name: Notification.Name("NewLocationLookup"),
                                               object: nil)
    }
    
    @objc
    func searchedResults(_ object: NSNotification) {
        guard let location = object.object as? CLLocation else { return }
        UserDefaults.standard.setValue(location.coordinate.latitude, forKey: "ManualSearchedLocation-lat")
        UserDefaults.standard.setValue(location.coordinate.longitude, forKey: "ManualSearchedLocation-lon")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnboardingViewControllerLevelFour")
            self?.show(vc, sender: self)
        }
    }
    
    @IBAction func searchLocation(_ sender: Any) {
        GWTransition.present(SavedLocationViewController(), from: self)
    }
    
}
