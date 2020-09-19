//
//  BaseViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/10/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, NotificationManagerDelegate {
    
    let notificationManager = NotificationManager()
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        notificationManager.delegate = self
        notificationManager.listen(for: NotificationName.observerID("weatherModel"), in: self)
        initUI()
    }

    func animate() {
        
    }
    func initUI() {}
    func applyAccessibility() {}
    func update(from notification: NSNotification) {}
    
}
