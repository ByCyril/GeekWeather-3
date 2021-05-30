//
//  DailyViewLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class DailyViewLayer: UIView, UICollectionViewDelegate {
        
    lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Daily>?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        dailyViewSetup()
    }
    
    private func dailyViewSetup() {
        backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
                
        let cellRegistration = UICollectionView.CellRegistration<DailyViewCell, Daily> {  (cell, indexPath, daily) in
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
            cell.tempLabels.text = daily.temp.max.kelvinToSystemFormat() + "  " + daily.temp.min.kelvinToSystemFormat()

        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Daily>(collectionView: collectionView, cellProvider: { collectionView, indexPath, daily in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: daily)
            
            return cell
        })
        
        layoutIfNeeded()
    }
    
    func populate(_ weatherModel: WeatherModel) {
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dataSource?.apply(dailySnapshot)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let daily = dataSource?.itemIdentifier(for: indexPath) {
            NotificationCenter.default.post(name: Notification.Name("DailyItemSelection"), object: daily)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
