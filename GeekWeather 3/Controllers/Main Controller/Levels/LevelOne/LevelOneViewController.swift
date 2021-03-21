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
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var tempIconContainer: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        createBlurView()
        
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: summaryLabel.font)
    
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
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
        summaryLabel.text = (currentWeatherData.weather.first?.description.capitalized)! + "\n⬆︎\(high)  ⬇︎\(low)"
                
        detailedViewLayer.update()
    }
    
    func displayData(_ currentWeatherData: Currently) {
        
        tempLabel.text = currentWeatherData.temp.kelvinToSystemFormat()
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? "na"
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? "na"
        
        summaryLabel.text = (currentWeatherData.weather.first?.description.capitalized)! + "\n⬆︎\(high)  ⬇︎\(low)"
        summaryLabel.numberOfLines = 0

        iconView.image = UIImage(named: currentWeatherData.weather.first!.icon)
        
        showElements()
        
        accessibilityElements()
    }
    
    func showElements() {
        print("Triggered",#function)
        var elementsRowOne = [iconView, tempLabel]
        var elementsRowTwo = [summaryLabel]
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
        detailedViewLayer.update()
        detailedViewLayer.alpha = 1
    }

    func shrink() {
        print("Triggered",#function)
        detailedViewLayer.d = 0
        
        [tempLabel, summaryLabel, iconView].forEach { (element) in
            element?.alpha = 0
            element?.transform = .init(scaleX: 0.01, y: 0.01)
        }
    }
    
    func accessibilityElements() {
        tempLabel.isAccessibilityElement = false
//        tempLabel.applyAccessibility(with: "Current Temperature", and: tempLabel.text, trait: .staticText)
        let icon = weatherModel?.current.weather.first?.main ?? ""
        let temp = tempLabel.text ?? ""
        
        tempIconContainer.applyAccessibility(with: "Current Weather Condition", and: "\(icon), \(temp)", trait: .staticText)
        summaryLabel.applyAccessibility(with: "Weather description", and: summaryLabel.text ?? "", trait: .staticText)
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
//        commentLabel.applyAccessibility(with: "High and Low temperatures for the day", and: "High of \(high), and a low of \(low)", trait: .staticText)
    }
    
}
