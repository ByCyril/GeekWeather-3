//
//  DailyContainerView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/12/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class DailyContainerView: UIView {
    
    lazy var dailyTableView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.flashScrollIndicators()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, Daily>?

    var containerView = UIView()
    
    let gradientLayer = CAGradientLayer()
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
 
    func createGradientLayer() {
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        setNeedsDisplay()
    }
    
    func initUI() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .clear
        layer.cornerRadius = 20
        layer.masksToBounds = true
        addSubview(dailyTableView)
        
        NSLayoutConstraint.activate([
            dailyTableView.topAnchor.constraint(equalTo: topAnchor),
            dailyTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func collectionViewSetup() {
        
        let registration = UICollectionView.CellRegistration<LevelTwoDailyViewCell, Daily> { cell, indexPath, daily in
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
            
        }
        
        dailyDataSource = UICollectionViewDiffableDataSource<Section, Daily>(collectionView: dailyTableView, cellProvider: { (collectionView, indexPath, daily) -> LevelTwoDailyViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: daily)
            return cell
        })
                
    }
    
    func updateCollection(_ weatherModel: WeatherModel) {
                
        var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        hourlySnapshot.appendSections([.main])
        hourlySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(hourlySnapshot)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createGradientLayer()
        initUI()
        collectionViewSetup()
    }
 
}
