//
//  LayerTwo.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LayerTwoView: UIView {
    
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, Daily>?
    
    lazy var hourlyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    var dailyView: UICollectionView!
    
    init() {
        super.init(frame: .zero)
        setupHourlyView()
        setupDailyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHourlyView() {
        addSubview(hourlyView)

        NSLayoutConstraint.activate([
            hourlyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyView.topAnchor.constraint(equalTo: topAnchor),
            hourlyView.heightAnchor.constraint(equalToConstant: 125)
        ])

        layoutIfNeeded()

        let registration = UICollectionView.CellRegistration<LevelTwoHourlyViewCell, Hourly> { cell, indexPath, data in
            let time = (indexPath.row == 0) ? "Now" : data.dt.convertHourTime()
            cell.timestampLabel.text = time
            cell.iconView.image = UIImage(named: data.weather.first!.icon)
            cell.tempLabel.text = data.temp.kelvinToSystemFormat()
        }

        hourlyDataSource = UICollectionViewDiffableDataSource(collectionView: hourlyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoHourlyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
    }
    
    func setupDailyView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        dailyView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dailyView.showsHorizontalScrollIndicator = false
        dailyView.alwaysBounceHorizontal = true
        dailyView.translatesAutoresizingMaskIntoConstraints = false
        dailyView.backgroundColor = .clear
        
        addSubview(dailyView)
        
        let padding: CGFloat = 25

        NSLayoutConstraint.activate([
            dailyView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor, constant: padding),
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dailyView.heightAnchor.constraint(equalToConstant: 125)
        ])

        layoutIfNeeded()

        let registration = UICollectionView.CellRegistration<LevelTwoDailyViewCell, Daily> { (cell, indexPath, daily) in

            let summary = daily.weather.first!.description

            if indexPath.row == 0 {
                cell.dayLabel.text = "Today"
                cell.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            } else {
                let day = Double(daily.dt).date(.shortDay)
                cell.dayLabel.text = day
                cell.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            }

            cell.iconView.image = UIImage(named: daily.weather.first!.icon)
            cell.highTempLabel.text = daily.temp.max.kelvinToSystemFormat()
            cell.lowTempLabel.text = daily.temp.min.kelvinToSystemFormat()
        }

        dailyDataSource = UICollectionViewDiffableDataSource(collectionView: dailyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoDailyViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
            cell.verticalLayout()
            return cell
        })
    }
    
    func populate(_ weatherModel: WeatherModel) {
        var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
        hourlySnapshot.appendSections([.main])
        hourlySnapshot.appendItems(Array(weatherModel.hourly[..<20]))
        hourlyDataSource?.apply(hourlySnapshot)
        
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(dailySnapshot)
    }
    
}
