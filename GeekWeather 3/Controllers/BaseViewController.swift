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
        notificationManager.delegate = self
        notificationManager.listen(for: NotificationName.observerID("weatherModel"), in: self)
        initUI()
        applyGradient()
    }
    
    func applyGradient() {
        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [UIColor.init(rgb: 0xF4B100).cgColor, UIColor.init(rgb: 0xFD6B00).cgColor]
        gradientLayer.colors = [UIColor.init(rgb: 0x307ECD).cgColor, UIColor.init(rgb: 0x3344A0).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func animate() {
        
    }
    func initUI() {}
    func applyAccessibility() {}
    func update(from notification: NSNotification) {}
    
}
