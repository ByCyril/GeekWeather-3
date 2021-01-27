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
   
    private var animationView: AnimationView!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var detailedViewLayer: DetailedViewLayer!
    
    @IBOutlet var weatherAlertButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        createBlurView()
        
        weatherAlertButton.titleLabel?.font = GWFont.AvenirNext(style: .Bold, size: 15)
        weatherAlertButton.layer.cornerRadius = 10
        weatherAlertButton.isHidden = true
        weatherAlertButton.addTarget(self, action: #selector(presentWeatherAlertView), for: .touchUpInside)
        
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: commentLabel.font)
    
        [tempLabel, summaryLabel, commentLabel].forEach { (element) in
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
            displayData(weatherModel.current)
            detailedViewLayer.populate(weatherModel)
            
            if let alerts = weatherModel.alerts {
                weatherAlertButton.isHidden = false
                weatherAlertButton.transform = .init(translationX: 0, y: -100)
                
                weatherAlert(alerts)
            } else {
                weatherAlertButton.isHidden = true
            }
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = " " + currentWeatherData.temp.kelvinToSystemFormat()
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
        commentLabel.text = "⬆︎\(high)  ⬇︎\(low)"
        
        detailedViewLayer.update()
    }
    
    func displayData(_ currentWeatherData: Currently) {
        
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        
        summaryLabel.text = currentWeatherData.weather.first?.description.capitalized
        summaryLabel.numberOfLines = 0
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? "na"
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? "na"
        
        commentLabel.text = "⬆︎\(high)  ⬇︎\(low)"
        commentLabel.numberOfLines = 0
        
        iconView.image = UIImage(named: currentWeatherData.weather.first!.icon)
        
        var elementsRowOne = [iconView, tempLabel]
        var elementsRowTwo = [summaryLabel, commentLabel]
        var a: Double = 0
        
        while !elementsRowOne.isEmpty {
            let element = elementsRowOne.removeFirst()
            a += 0.15
            UIView.animate(withDuration: 0.4, delay: a, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                element?.alpha = 1
                element?.transform = .identity
            }
        }
        
        var b: Double = 0.05
        while !elementsRowTwo.isEmpty {
            let element = elementsRowTwo.removeFirst()
            b += 0.15
            UIView.animate(withDuration: 0.4, delay: b, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                element?.alpha = 1
                element?.transform = .identity
            }
        }
        
        detailedViewLayer.alpha = 1
        
        accessibilityElements()
    }
    
    func weatherAlert(_ alerts: [Alert]) {
        UIView.animate(withDuration: 0.4, delay: 1, options: .curveEaseInOut) {
            self.weatherAlertButton.transform = .identity
        }
    }

    @objc
    func presentWeatherAlertView() {
        guard let alert = weatherModel?.alerts else { return }
        NotificationCenter.default.post(name: NSNotification.Name("PresentWeatherAlert"), object: alert)
    }
    
    func shrink() {
        
        [tempLabel, summaryLabel, commentLabel, iconView].forEach { (element) in
            element?.alpha = 0
            element?.transform = .init(scaleX: 0.01, y: 0.01)
        }
        detailedViewLayer.d = 0
//        detailedViewLayer.animatedCell.removeAll()
    }
    
    func accessibilityElements() {
        tempLabel.applyAccessibility(with: "Current Temperature", and: tempLabel.text, trait: .staticText)
    }
    
}
