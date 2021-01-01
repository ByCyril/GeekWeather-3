//
//  NotificationManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

@objc protocol NotificationManagerDelegate: AnyObject {
    func didRecieve(from notification: NSNotification)
}

final class NotificationManager {
    
    weak var delegate: NotificationManagerDelegate?
    
    func listen(for name: Notification.Name, in vc: Any) {
        guard let delegate = self.delegate else { return }
        NotificationCenter.default.addObserver(vc, selector: #selector(delegate.didRecieve(from:)), name: name, object: nil)
    }
    
    func post(data: [AnyHashable: Any], to name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: data)
    }
    
    func terminate(observer: Notification.Name, from vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: observer, object: nil)
    }
}
