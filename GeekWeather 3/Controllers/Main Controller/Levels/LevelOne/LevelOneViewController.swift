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
    @IBOutlet var locationLabel: UILabel!
        
    init(frame: CGRect,_ bundle: Bundle = Bundle.main) {
        super.init(frame: frame)
        
        let view = bundle.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        view.backgroundColor = UIColor(named: "demo-background")!
        
        createBlurView()
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        animationView.animationSpeed = 1.5

        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: tempLabel.font)

        locationLabel.font = UIFontMetrics(forTextStyle: .headline)
            .scaledFont(for: locationLabel.font)
        
        [tempLabel, locationLabel].forEach { (element) in
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
        }
        
        if let location = notification.userInfo?["location"] as? String {
            locationLabel.text = location
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
    }
    
    func displayData(_ currentWeatherData: Currently) {
        
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        animationView.animation = Animation.named(AssetMap.shared.animation(currentWeatherData.weather.first!.icon))
        animationView.play()
        showElements()
        
//        accessibilityElements()
    }
    
    func showElements() {
        [tempLabel].forEach { (element) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                element?.alpha = 1
                element?.transform = .identity
            }
        }
    }

    func shrink() {
        
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
