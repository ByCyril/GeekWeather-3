//
//  CurrentlyViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class CurrentlyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationManager.listen(for: Observe.data.currentWeatherData, in: self)
    }
    
    override func update(from notification: NSNotification) {
        
    }
}
