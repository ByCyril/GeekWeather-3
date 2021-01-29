//
//  HourlyView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/18/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
    
final class HourlyViewLayer: UIView, UICollectionViewDelegateFlowLayout {
    
    var hourlyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.flashScrollIndicators()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var weatherModel: WeatherModel?
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        initUI()
        hourlyViewSetup()
    }
    
    private func initUI() {
        addSubview(hourlyView)
        
        NSLayoutConstraint.activate([
            hourlyView.topAnchor.constraint(equalTo: topAnchor),
            hourlyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    private func hourlyViewSetup() {
        hourlyView.delegate = self
        
        let registration = UICollectionView.CellRegistration<HourlyViewCell, Hourly> { cell, indexPath, data in
            
            if (data.weather.first!.icon == "sunrise" || data.weather.first!.icon == "sunset") {
                let time = data.dt.convertTime().lowercased()
                cell.timestampLabel.text = time
                cell.timestampLabel.adjustsFontSizeToFitWidth = true
                cell.timestampLabel.minimumScaleFactor = 0.5
                cell.iconView.image = UIImage(named: data.weather.first!.icon)
                cell.tempLabel.text = data.weather.first!.icon.capitalized
                cell.tempLabel.adjustsFontSizeToFitWidth = true
                cell.tempLabel.minimumScaleFactor = 0.5
                
            } else {
                let time = (indexPath.row == 0) ? "Now" : data.dt.convertHourTime().lowercased()
                
                cell.timestampLabel.text = time
                cell.iconView.image = UIImage(named: data.weather.first!.icon)
                cell.tempLabel.text = data.temp.kelvinToSystemFormat()
                cell.tempLabel.adjustsFontSizeToFitWidth = false
                cell.tempLabel.minimumScaleFactor = 1
            }
        }
        
        hourlyDataSource = UICollectionViewDiffableDataSource(collectionView: hourlyView, cellProvider: { (collectionView, indexpath, data) -> HourlyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
        
    }
    
    func populate(_ weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
        hourlySnapshot.appendSections([.main])
        hourlySnapshot.appendItems(Array(weatherModel.hourly[..<20]))
        hourlyDataSource?.apply(hourlySnapshot)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let hourly = weatherModel?.hourly else { return CGSize(width: 60, height: 100) }
        
        if hourly[indexPath.row].weather.first?.icon == "sunrise" || hourly[indexPath.row].weather.first?.icon == "sunset" {
            return CGSize(width: 90, height: 100)
        } else {
            return CGSize(width: 60, height: 100)
        }
    }
}
