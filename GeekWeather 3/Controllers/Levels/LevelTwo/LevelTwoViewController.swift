//
//  LebelTwoViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

enum Section {
    case main
}

final class LevelTwoViewController: BaseView {
   
    @IBOutlet var containerView: UIView!
    
    lazy var hourlyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var dailyView: UICollectionView = {
        var layout = UICollectionLayoutListConfiguration(appearance: .grouped)
        layout.backgroundColor = .clear
        layout.showsSeparators = false
        let configuration = UICollectionViewCompositionalLayout.list(using: layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
        
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, Daily>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        hourlyViewSetup()
        dailyViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func hourlyViewSetup() {
        addSubview(hourlyView)
        
        NSLayoutConstraint.activate([
            hourlyView.topAnchor.constraint(equalTo: topAnchor),
            hourlyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        layoutIfNeeded()
                
        let registration = UICollectionView.CellRegistration<LevelTwoHourlyViewCell, Hourly> { cell, indexPath, data in
            cell.iconView.image = UIImage(named: data.weather.first!.icon)
            cell.tempLabel.text = data.temp.temp()
            cell.timestampLabel.text = data.dt.date(.hour)
        }
        
        hourlyDataSource = UICollectionViewDiffableDataSource(collectionView: hourlyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoHourlyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
        
    }
 
    private func dailyViewSetup() {
        
        addSubview(dailyView)

        NSLayoutConstraint.activate([
            dailyView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor),
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dailyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        layoutIfNeeded()
        
        let registration = UICollectionView.CellRegistration<LevelTwoDailyViewCell, Daily> { (cell, indexPath, daily) in
            
            let summary = daily.weather.first!.description
            
            if indexPath.row == 0 {
                cell.dayLabel.text = "Today"
                cell.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
            } else {
                let day = Double(daily.dt).date(.day)
                cell.dayLabel.text = day
                cell.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
            }
            
//            if daily.pop >= 0.15 {
//                cell.percLabel.text = "Chance of Rain " + daily.pop.percentage(chop: false)
//                cell.percLabel.isHidden = false
//            } else {
//                cell.percLabel.isHidden = true
//            }
            
            cell.iconView.image = UIImage(named: daily.weather.first!.icon)
            cell.highTempLabel.text = daily.temp.max.temp()
            cell.lowTempLabel.text = daily.temp.min.temp()
        }
        
        dailyDataSource = UICollectionViewDiffableDataSource(collectionView: dailyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoDailyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
        
    }
    
    override func update(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        populateHourlyView(with: weatherModel.hourly)
        populateDailyView(with: weatherModel.daily)
    }
    
    
    private func populateHourlyView(with data: [Hourly]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(data[..<20]))
        hourlyDataSource?.apply(snapshot)
    }
    
    private func populateDailyView(with data: [Daily]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dailyDataSource?.apply(snapshot)
    }
    
}
