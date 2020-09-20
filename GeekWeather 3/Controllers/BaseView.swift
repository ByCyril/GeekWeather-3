//
//  BaseView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/10/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class BaseView: UIView, NotificationManagerDelegate {
    
    let notificationManager = NotificationManager()
    
    let gradientLayer = CAGradientLayer()
    var viewControllerPresenter: UIViewController?
    
    private var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        xibSetup()
        notificationManager.delegate = self
        notificationManager.listen(for: NotificationName.observerID("weatherModel"), in: self)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    func animate() {
        
    }
    func initUI() {}
    func applyAccessibility() {}
    func update(from notification: NSNotification) {}
    
    
}
