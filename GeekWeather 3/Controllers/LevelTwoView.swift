//
//  LevelTwoView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelTwoView: BaseView {
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
    override init(frame: CGRect) {
        super.init(frame: frame)
//        notificationManager.listen(for: Observe.data.currentWeatherData, in: self)
        backgroundColor = .white
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {

        label.backgroundColor = .blue
        addSubview(label)
    }
    
    override func update(from notification: NSNotification) {}
}
