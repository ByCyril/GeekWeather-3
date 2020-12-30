//
//  GWTest.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class GWTest {
    
    static func forceViewController() -> UIViewController? {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnboardingViewControllerLevelOne")
        return nil
    }
}
