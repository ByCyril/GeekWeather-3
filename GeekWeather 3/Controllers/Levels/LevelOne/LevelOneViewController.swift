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
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        locationLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: locationLabel.font)
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: commentLabel.font)
        
        
        [locationLabel, tempLabel, summaryLabel, commentLabel].forEach { (element) in
            element?.adjustsFontSizeToFitWidth = true
            
//            element?.layer.shadowOffset = CGSize(width: 0, height: 5)
//            element?.layer.shadowOpacity = 0.25
//            element?.layer.shadowColor = UIColor.black.cgColor
//            element?.layer.shadowRadius = 5
        }
        
        notificationManager.listen(for: NotificationName.observerID("currentLocation"), in: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func getContentOffset(_ offset: CGPoint) {
        guard offset.y < 0 else { return }
//        locationLabel.frame.origin.y -= offset.y
//        locationLabel.transform = .init(translationX: 0, y: offset.y)
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
}
