//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelOneViewController: BaseView {
   
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        
        locationLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: locationLabel.font)
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: commentLabel.font)
        
        locationLabel.adjustsFontForContentSizeCategory = true
        tempLabel.adjustsFontForContentSizeCategory = true
        summaryLabel.adjustsFontForContentSizeCategory = true
        commentLabel.adjustsFontForContentSizeCategory = true
        
        notificationManager.listen(for: NotificationName.observerID("currentLocation"), in: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func animate() {
        let views = [locationLabel, tempLabel, summaryLabel, commentLabel]
            
        views.forEach { (element) in
            element?.alpha = 0
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            views.forEach { (element) in
                element?.alpha = 1
            }
        }
    }
    
    override func update(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            DispatchQueue.main.async {
                self.displayData(weatherModel.current)
            }
        }
        
        if let currentLocation = notification.userInfo?["currentLocation"] as? String {
            UIView.transition(with: locationLabel, duration: 1, options: [.curveEaseInOut, .transitionFlipFromBottom], animations: {
                self.locationLabel.text = currentLocation
            })
        }
        
    }

    func displayData(_ currentWeatherData: Currently) {
                
        tempLabel.text = currentWeatherData.temp.temp()
        summaryLabel.text = currentWeatherData.weather.first?.main ?? ""
        commentLabel.text = "Feels like " + currentWeatherData.feels_like.temp()
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.tempLabel.alpha = 1
            self?.summaryLabel.alpha = 1
            self?.commentLabel.alpha = 1
        }
    }
    
    func loadXib() {
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        view.frame = bounds
        view.backgroundColor = .clear
        view.layoutIfNeeded()
        addSubview(view)
    }
    
}
