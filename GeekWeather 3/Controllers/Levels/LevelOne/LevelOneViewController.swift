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
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    
    var currentWeatherData: Currently?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: commentLabel.font)
                
        [tempLabel, summaryLabel, commentLabel].forEach { (element) in
            element?.adjustsFontForContentSizeCategory = true
            element?.adjustsFontSizeToFitWidth = true
            element?.textColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override func update(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            DispatchQueue.main.async { [weak self] in
                self?.currentWeatherData = weatherModel.current
                self?.displayData(weatherModel.current)
            }
        }
    }

    func displayData(_ currentWeatherData: Currently) {
                
        tempLabel.text = " " + currentWeatherData.temp.temp()
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
