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

final class LevelTwoViewController: BaseView, UITableViewDelegate {
    
    @IBOutlet var containerView: UIView!
    
    private var dailyDataSource: UITableViewDiffableDataSource<Section, Daily>?
 
    let dailyTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        createBlurView()
        dailyViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if traitCollection.preferredContentSizeCategory >= .extraExtraExtraLarge {
            return UITableView.automaticDimension
        } else {
            return dailyTableView.frame.size.height / 8
        }
    }
 
    private func dailyViewSetup() {
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.delegate = self
        dailyTableView.backgroundColor = .clear
        dailyTableView.separatorStyle = .none
        
        addSubview(dailyTableView)

        NSLayoutConstraint.activate([
            dailyTableView.topAnchor.constraint(equalTo: topAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
            dailyTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        dailyTableView.register(LevelTwoDailyViewCell.self, forCellReuseIdentifier: "cell")
        
        dailyDataSource = UITableViewDiffableDataSource<Section, Daily>(tableView: dailyTableView, cellProvider: { (tableView, indexPath, daily) -> LevelTwoDailyViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LevelTwoDailyViewCell
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
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(dailySnapshot)
    }
    
    override func didUpdateValues() {
        dailyTableView.reloadData()
    }

}

extension LevelTwoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let dailyObj = dailyDataSource?.itemIdentifier(for: indexPath) else { return }
//        NotificationCenter.default.post(name: Notification.Name("ShowDetailsView"), object: dailyObj)
    }
}
