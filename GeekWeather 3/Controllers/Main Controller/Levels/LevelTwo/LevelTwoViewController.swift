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
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var dailyViewHeightConstraint: NSLayoutConstraint?
    
    init(frame: CGRect,_ bundle: Bundle = .main) {
        super.init(frame: frame)
        
        let view = bundle.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        view.backgroundColor = UIColor(named: "demo-background")!

        createBlurView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        hourlyViewLayer.populate(weatherModel)
        dailyViewLayer.populate(weatherModel)
        updateStoryboardConstraints()
    }
    
    override func didUpdateValues() {
        hourlyViewLayer.hourlyView.reloadData()
        dailyViewLayer.collectionView.reloadData()
        updateStoryboardConstraints()
    }
    
    func updateStoryboardConstraints() {
        dailyViewHeightConstraint?.constant = dailyViewLayer.collectionView.collectionViewLayout.collectionViewContentSize.height + 150
        dailyViewLayer.layoutIfNeeded()
    }

}
