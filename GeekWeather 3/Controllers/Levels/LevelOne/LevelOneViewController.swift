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
        
    @IBOutlet var hourlyView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 75, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.flashScrollIndicators()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelOneViewController", owner: self)!.first as! LevelOneViewController
        loadXib(view, self)
        
        createBlurView()
        hourlyViewSetup()
        
        tempLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: tempLabel.font)
        summaryLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: summaryLabel.font)
        commentLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: commentLabel.font)
        
        [tempLabel, summaryLabel, commentLabel].forEach { (element) in
            element?.adjustsFontForContentSizeCategory = true
            element?.adjustsFontSizeToFitWidth = true
            element?.textColor = .white
        }
    }
    
    private func hourlyViewSetup() {
        hourlyView.delegate = self
        
        let registration = UICollectionView.CellRegistration<LevelTwoHourlyViewCell, Hourly> { cell, indexPath, data in
            
            if (data.weather.first!.icon == "sunrise" || data.weather.first!.icon == "sunset") {
                if data.dt < Date().timeIntervalSince1970 {
                    return
                }
                let time = data.dt.convertTime()
                cell.timestampLabel.text = time
                cell.timestampLabel.adjustsFontSizeToFitWidth = true
                cell.timestampLabel.minimumScaleFactor = 0.5
                cell.iconView.image = UIImage(named: data.weather.first!.icon)
                cell.tempLabel.text = data.weather.first!.icon.capitalized
                cell.tempLabel.adjustsFontSizeToFitWidth = true
                cell.tempLabel.minimumScaleFactor = 0.5
                
            } else {
                let time = (indexPath.row == 0) ? "Now" : data.dt.convertHourTime()
                cell.timestampLabel.adjustsFontSizeToFitWidth = false
                cell.timestampLabel.minimumScaleFactor = 1
                cell.timestampLabel.text = time
                cell.iconView.image = UIImage(named: data.weather.first!.icon)
                cell.tempLabel.text = data.temp.kelvinToSystemFormat()
                cell.tempLabel.adjustsFontSizeToFitWidth = false
                cell.tempLabel.minimumScaleFactor = 1
            }
        }
        
        hourlyDataSource = UICollectionViewDiffableDataSource(collectionView: hourlyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoHourlyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override func didRecieve(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            self.weatherModel = weatherModel
            displayData(weatherModel.current)
            
            var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
            hourlySnapshot.appendSections([.main])
            hourlySnapshot.appendItems(Array(weatherModel.hourly[..<20]))
            hourlyDataSource?.apply(hourlySnapshot)
        }
    }
    
    override func didUpdateValues() {
        guard let currentWeatherData = weatherModel?.current else { return }
        tempLabel.text = " " + currentWeatherData.temp.kelvinToSystemFormat()
        
        let high = weatherModel?.daily.first?.temp.max.kelvinToSystemFormat() ?? ""
        let low = weatherModel?.daily.first?.temp.min.kelvinToSystemFormat() ?? ""
        
        commentLabel.text = "⬆︎\(high)  ⬇︎\(low)"
        
        hourlyView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let hourly = weatherModel?.hourly else { return CGSize(width: 75, height: 128) }
        
        if hourly[indexPath.row].weather.first?.icon == "sunrise" || hourly[indexPath.row].weather.first?.icon == "sunset" {
            return CGSize(width: 110, height: 128)
        } else {
            return CGSize(width: 75, height: 128)
        }
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
