//
//  BaseViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class BaseView: UIView, NotificationManagerDelegate {
 
    let notificationManager = NotificationManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        notificationManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(from notification: NSNotification) {}
     
}