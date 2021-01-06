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
        let nav = UINavigationController(rootViewController: vc)
        let attributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Bold, size: 35)]
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.largeTitleTextAttributes = attributes
        nav.navigationItem.largeTitleDisplayMode = .always
        from.present(nav, animated: true, completion: nil)
    }
}
