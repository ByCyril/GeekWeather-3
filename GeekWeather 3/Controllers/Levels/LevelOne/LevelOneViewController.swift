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
    @IBOutlet var iconView: UIImageView!
    
    var currentWeatherData: Currently?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        locationLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: locationLabel.font)
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: commentLabel.font)
        
        locationLabel.alpha = 0
        
        [locationLabel, tempLabel, summaryLabel, commentLabel].forEach { (element) in
            element?.adjustsFontForContentSizeCategory = true
            element?.adjustsFontSizeToFitWidth = true
        }
        
        notificationManager.listen(for: NotificationName.observerID("currentLocation"), in: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func getContentOffset(_ offset: CGPoint) {
        let alpha = 1 - (offset.y / frame.size.height)
        
        locationLabel.alpha = alpha
        tempLabel.alpha = alpha
        summaryLabel.alpha = alpha
        commentLabel.alpha = alpha
    }
        
    override func update(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            DispatchQueue.main.async { [weak self] in
                self?.currentWeatherData = weatherModel.current
                self?.displayData(weatherModel.current)
            }
        }
        
        if let currentLocation = notification.userInfo?["currentLocation"] as? String {
//            locationLabel.text = currentLocation
//            
//            UIView.animate(withDuration: 0.4) { [weak self] in
//                self?.locationLabel.alpha = 1
//            }
        }
    }

    func displayData(_ currentWeatherData: Currently) {
                
        tempLabel.text = currentWeatherData.temp.temp()
        summaryLabel.text = currentWeatherData.weather.first?.description.capitalized ?? ""
        commentLabel.text = "Feels like " + currentWeatherData.feels_like.temp()
        iconView.image = UIImage(named: currentWeatherData.weather.first!.icon)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.tempLabel.alpha = 1
            self?.summaryLabel.alpha = 1
            self?.commentLabel.alpha = 1
        }
        
        accessibilityElements()
    }
    
    func accessibilityElements() {
        tempLabel.applyAccessibility(with: "Current Temperature", and: tempLabel.text, trait: .staticText)
    }
}
