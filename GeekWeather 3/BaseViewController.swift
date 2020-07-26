//
//  BaseViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func listen(for name: Notification.Name, in vc: UIViewController) {
        NotificationCenter.default.addObserver(vc, selector: #selector(update(from:)), name: name, object: nil)
    }
    
    func terminate(observer: Notification.Name, from vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: observer, object: nil)
    }
    
    @objc
    func update(from notification: NSNotification) {}
}
