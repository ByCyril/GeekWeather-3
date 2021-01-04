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
    
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, Daily>?
    
    private var dailyView: UICollectionView!
    
    lazy var hourlyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated((frame.height - 125) / 8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: .fixed(8))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        createBlurView()
        hourlyViewSetup()
        dailyViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func hourlyViewSetup() {
        addSubview(hourlyView)
        
        NSLayoutConstraint.activate([
            hourlyView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            hourlyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hourlyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hourlyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        layoutIfNeeded()
        
        let registration = UICollectionView.CellRegistration<LevelTwoHourlyViewCell, Hourly> { cell, indexPath, data in
            
            if data.weather.first!.icon == "sunrise" || data.weather.first!.icon == "sunset" {
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
    
    private func dailyViewSetup() {

        dailyView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        dailyView.translatesAutoresizingMaskIntoConstraints = false
        dailyView.backgroundColor = .clear
        dailyView.isScrollEnabled = false
        dailyView.delegate = self

        addSubview(dailyView)
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            dailyView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor, constant: padding),
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dailyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
        
        let registration = UICollectionView.CellRegistration<LevelTwoDailyViewCell, Daily> { (cell, indexPath, daily) in
            
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
            cell.frame.size = CGSize(width: self.dailyView.frame.size.width, height: self.dailyView.frame.size.height / 8)
        }
        
        dailyDataSource = UICollectionViewDiffableDataSource(collectionView: dailyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoDailyViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
            cell.horizontalLayout()
            return cell
        })
        
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        populate(with: weatherModel)
    }
    
    private func populate(with weatherModel: WeatherModel) {
        
        var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
        hourlySnapshot.appendSections([.main])
        hourlySnapshot.appendItems(Array(weatherModel.hourly[..<20]))
        hourlyDataSource?.apply(hourlySnapshot)
        
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(dailySnapshot)
    }

    override func didUpdateValues() {
        hourlyView.reloadData()
        dailyView.reloadData()
    }

}

extension LevelTwoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dailyObj = dailyDataSource?.itemIdentifier(for: indexPath) else { return }
        NotificationCenter.default.post(name: Notification.Name("ShowDetailsView"), object: dailyObj)
    }
}
