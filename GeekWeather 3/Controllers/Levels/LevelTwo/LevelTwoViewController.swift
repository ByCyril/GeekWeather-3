//
//  LebelTwoViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

enum Section {
    case main
}

final class LevelTwoViewController: BaseView, UITableViewDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var hourlyViewLayer: HourlyViewLayer!
    @IBOutlet var dailyViewLayer: DailyViewLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        createBlurView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        hourlyViewLayer.populate(weatherModel)
        dailyViewLayer.populate(weatherModel)
    }
    
    override func didUpdateValues() {
        hourlyViewLayer.hourlyView.reloadData()
        dailyViewLayer.dailyTableView.reloadData()
    }

}
