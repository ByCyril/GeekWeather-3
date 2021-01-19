//
//  DailyViewLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class DailyViewLayer: UIView, UITableViewDelegate {
    
    private var dailyDataSource: UITableViewDiffableDataSource<Section, Daily>?

    let dailyTableView = UITableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dailyViewSetup()
    }
    
    private func dailyViewSetup() {
        backgroundColor = .clear
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.delegate = self
        dailyTableView.backgroundColor = .clear
        dailyTableView.separatorStyle = .none
        
        addSubview(dailyTableView)

        NSLayoutConstraint.activate([
            dailyTableView.topAnchor.constraint(equalTo: topAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dailyTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        dailyTableView.register(DailyViewCell.self, forCellReuseIdentifier: "cell")
        
        dailyDataSource = UITableViewDiffableDataSource<Section, Daily>(tableView: dailyTableView, cellProvider: { (tableView, indexPath, daily) -> DailyViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyViewCell
            let summary = daily.weather.first!.description
            
            if indexPath.row == 0 {
                cell.dayLabel.text = "Today"
                cell.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            } else {
                let day = Double(daily.dt).date(.day)
                cell.dayLabel.text = day
                cell.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            }
            
            cell.iconView.image = UIImage(named: daily.weather.first!.icon)
            cell.highTempLabel.text = daily.temp.max.kelvinToSystemFormat()
            cell.lowTempLabel.text = daily.temp.min.kelvinToSystemFormat()
            cell.selectionStyle = .none
            return cell
        })
        
        layoutIfNeeded()
    }
    
    func populate(_ weatherModel: WeatherModel) {
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(dailySnapshot)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if traitCollection.preferredContentSizeCategory >= .extraExtraExtraLarge {
            return UITableView.automaticDimension
        } else {
            return dailyTableView.frame.size.height / 8
        }
    }
}
