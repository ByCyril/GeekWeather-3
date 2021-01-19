//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import Lottie

final class LevelOneViewController: BaseView, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var containerView: UIView!
    
    private var animationView: AnimationView!
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var hourlyViewLayer: HourlyViewLayer!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        createBlurView()
        
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: summaryLabel.font)
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
   
    override func didRecieve(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            self.weatherModel = weatherModel
            displayData(weatherModel.current)
            hourlyViewLayer.populate(weatherModel)
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = " " + currentWeatherData.temp.kelvinToSystemFormat()
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
        commentLabel.text = "⬆︎\(high)  ⬇︎\(low)"
        hourlyViewLayer.hourlyView.reloadData()
    }
    
    func displayData(_ currentWeatherData: Currently) {
                
        tempLabel.text = " " + currentWeatherData.temp.kelvinToSystemFormat()
        
        summaryLabel.text = instructions(currentWeatherData.weather.first?.description.capitalized ?? "")
        summaryLabel.numberOfLines = 0
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
        commentLabel.text = "⬆︎\(high)  ⬇︎\(low)"
        commentLabel.numberOfLines = 0
        
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
    
    func instructions(_ text: String) -> String {
        if text == "Mock Data 👋🏼" {
            return "You've exceeded the number of API calls for the beta program. Your limit will reset on the next day."
        }
        return text
    }
 
}
