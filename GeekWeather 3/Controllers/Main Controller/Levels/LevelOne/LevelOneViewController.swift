//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import Lottie

final class LevelOneViewController: BaseView, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var animationView: AnimationView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var detailedViewLayer: DetailedViewLayer!
    @IBOutlet var locationLabel: UILabel!
        
    init(frame: CGRect,_ bundle: Bundle = Bundle.main) {
        super.init(frame: frame)
        
        let view = bundle.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        createBlurView()
        animationView.loopMode = .autoReverse
        animationView.backgroundColor = .clear
        animationView.animationSpeed = 1.5
//        titleLabel.numberOfLines = 2
//        titleLabel.adjustsFontSizeToFitWidth = true

//        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
//        summaryLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: summaryLabel.font)
    
        [tempLabel].forEach { (element) in
            element?.adjustsFontForContentSizeCategory = true
            element?.adjustsFontSizeToFitWidth = true
            element?.textColor = .white
        }
        
        shrink()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override func didRecieve(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            self.weatherModel = weatherModel
            
            animationView.play()
            displayData(weatherModel.current)
            detailedViewLayer.populate(weatherModel)
        }
        
        if let location = notification.userInfo?["location"] as? String {
            locationLabel.text = location
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        
//        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
//        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
                        
        detailedViewLayer.update()
    }
    
    func displayData(_ currentWeatherData: Currently) {
        
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        
//        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? "na"
//        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? "na"
        
//        summaryLabel.text = (currentWeatherData.weather.first?.description.capitalized)! + "\n⬆︎\(high)  ⬇︎\(low)"
//        summaryLabel.numberOfLines = 0

//        iconView.image = UIImage(named: currentWeatherData.weather.first!.icon)
        
        showElements()
        
//        accessibilityElements()
    }
    
    func showElements() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) { [weak self] in
            self?.tempLabel.alpha = 1
            self?.tempLabel.transform = .identity
        }
        detailedViewLayer.update()
        detailedViewLayer.alpha = 1
    }

    func shrink() {
        detailedViewLayer.d = 0
        
        [tempLabel].forEach { (element) in
            element?.alpha = 0
            element?.transform = .init(scaleX: 0.01, y: 0.01)
        }
    }
    
    func accessibilityElements() {
        tempLabel.isAccessibilityElement = false
//        tempLabel.applyAccessibility(with: "Current Temperature", and: tempLabel.text, trait: .staticText)
//        let icon = weatherModel?.current.weather.first?.main ?? ""
//        let temp = tempLabel.text ?? ""
        
//        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
//        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
//        commentLabel.applyAccessibility(with: "High and Low temperatures for the day", and: "High of \(high), and a low of \(low)", trait: .staticText)
    }
    
}
