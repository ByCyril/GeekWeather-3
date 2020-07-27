//
//  CurrentlyViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelOneView: BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        notificationManager.listen(for: Observe.data.currentWeatherData, in: self)
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(from notification: NSNotification) {}
}

final class LevelTwoView: BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        notificationManager.listen(for: Observe.data.currentWeatherData, in: self)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(from notification: NSNotification) {}
}
