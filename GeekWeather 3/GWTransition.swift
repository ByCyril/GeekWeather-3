//
//  GWTransition.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class GWTransition {
    static func present(_ vc: UIViewController, from: UIViewController) {
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        nav.navigationBar.prefersLargeTitles = true
        from.present(nav, animated: true, completion: nil)
    }
}
