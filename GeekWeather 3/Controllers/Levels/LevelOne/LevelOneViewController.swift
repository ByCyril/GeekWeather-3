//
//  LevelOneViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelOneViewController: BaseViewController {
   
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func presentLocationSearch() {
        let vc = SavedLocationViewController()
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        nav.navigationBar.prefersLargeTitles = true
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func presentSettingController() {
        let vc = SettingsController()
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        nav.navigationBar.prefersLargeTitles = true
        present(nav, animated: true, completion: nil)
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
