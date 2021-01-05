//
//  OnboardingViewControllerLevelFour.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class OnboardingViewControllerLevelFour: OnboardingBaseViewController {
    
    @IBOutlet weak var continueButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.borderWidth = 2
        continueButton.layer.borderColor = continueButton.titleLabel?.textColor.cgColor
        continueButton.layer.cornerRadius = 10
        
        UserDefaults.standard.setValue(true, forKey: "ExistingUser")
    }
    
    
    @IBAction func continueToApp(_ sender: Any) {
        var viewController: UIViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController = MainPadController()
        } else {
            viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainViewController")
        }
        
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
