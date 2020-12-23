//
//  LebelTwoViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelTwoCellView: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: dayLabel.font)
        highTempLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: highTempLabel.font)
        lowTempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: lowTempLabel.font)
        
        [dayLabel, highTempLabel, lowTempLabel].forEach { (element) in
            element?.isAccessibilityElement = false
            element?.adjustsFontForContentSizeCategory = true
            element?.sizeToFit()
            element?.numberOfLines = 0
        }
        
        isAccessibilityElement = true
        
    }
    
//    override func updateConstraints() {
//        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
//            guard let str = dayLabel.text else { return }
//            let index = str.index(str.startIndex, offsetBy: 3)
//            dayLabel.text = String(str[..<index])
//        }
//        super.updateConstraints()
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
//
//        if isAccessibilityCategory != previousTraitCollection?.preferredContentSizeCategory.isAccessibilityCategory {
//            setNeedsUpdateConstraints()
//        }
//    }
}

final class LevelTwoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
}

enum Section {
    case main
}

final class LevelTwoViewController: BaseView, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet var containerView: UIView!
    @IBOutlet var dailyTableView: UITableView!
    @IBOutlet var hourlyCollectionView: UICollectionView!
    
    private var weatherModel: WeatherModel?
    private var dataSource: UITableViewDiffableDataSource<Section, Daily>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        tableViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func getContentOffset(_ offset: CGPoint) {
        
        let height = frame.size.height
        var alpha: CGFloat = 0
        
        if offset.y <= height {
            alpha = (1 - ((offset.y + height) / height)) * -1
        } else {
            alpha = 1 - ((offset.y - height) / height)
        }
        
        dailyTableView.alpha = alpha
        hourlyCollectionView.alpha = alpha
        
    }
    
    private func tableViewSetup() {
        
        dailyTableView.backgroundView?.backgroundColor = .clear
        dailyTableView.backgroundColor = .clear
        dailyTableView.estimatedRowHeight = 70
        dailyTableView.rowHeight = UITableView.automaticDimension
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        dailyTableView.register(UINib(nibName: "LevelTwoCellView", bundle: .main), forCellReuseIdentifier: "cell")
        
        hourlyCollectionView.backgroundView?.backgroundColor = .clear
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        hourlyCollectionView.register(UINib(nibName: "LevelTwoCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (weatherModel?.hourly.count ?? 0) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LevelTwoCollectionViewCell
        
        let hourly = weatherModel!.hourly[indexPath.row]
        let summary = hourly.weather.first!.description
        
        if indexPath.row == 0 {
            cell?.timestampLabel.text = "Now"
            cell?.applyAccessibility(with: "Today's forecast by the hour", and: "Right now. It is \(hourly.temp.temp()) and \(summary).", trait: .staticText)
        } else {
            let time = Double(hourly.dt).date(.hour)
            cell?.timestampLabel.text = time
            cell?.applyAccessibility(with: time, and: "It is \(hourly.temp.temp()) and \(summary).", trait: .staticText)
        }
        
        cell?.tempLabel.text = hourly.temp.temp()
        cell?.iconView.image = UIImage(named: hourly.weather.first!.icon)
   
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let dailyCount = weatherModel?.daily.count else { return 0 }
        return (tableView.frame.size.height / CGFloat(dailyCount))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LevelTwoCellView
        cell?.backgroundColor = .clear
        
        let daily = weatherModel!.daily[indexPath.row]
        let summary = daily.weather.first!.description
        
        if indexPath.row == 0 {
            cell?.dayLabel.text = "Today"
            cell?.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
        } else {
            let day = Double(daily.dt).date(.day)
            cell?.dayLabel.text = day
            cell?.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
        }
        
        cell?.iconView.image = UIImage(named: daily.weather.first!.icon)
        cell?.highTempLabel.text = daily.temp.max.temp()
        cell?.lowTempLabel.text = daily.temp.min.temp()
        
        return cell!
    }
    
    override func update(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
        hourlyCollectionView.reloadData()
        dailyTableView.reloadData()
    }
    
}
