//
//  OnboardingViewControllerLevelThree.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import CoreLocation

final class OnboardingViewControllerLevelThree: OnboardingBaseViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

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
        guard let location = object.object as? SavedLocation else { return }
        
        let coord = ["lon": location.location!.coordinate.longitude,
                     "lat": location.location!.coordinate.latitude]
        sharedUserDefaults?.setValue(coord, forKey: SharedUserDefaults.Keys.DefaultLocation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnboardingViewControllerLevelFour")
            self?.show(vc, sender: self)
        }
    }
    
    @IBAction func searchLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SavedLocationViewController")
        present(vc, animated: true, completion: nil)
    }
    
}
