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
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
}

final class LevelTwoViewController: BaseViewController {
  
    enum Section {
        case main
    }
    
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    private var weatherData: WeatherModel?
    private var dataSource: UITableViewDiffableDataSource<Section, Daily>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        configureDataSource()
    }
    
    private func tableViewSetup() {
        dailyTableView.register(UINib(nibName: "LevelTwoCellView", bundle: nil), forCellReuseIdentifier: "cell")
    }
  
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Daily>(tableView: dailyTableView, cellProvider: { (tableView, indexPath, daily) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LevelTwoCellView
            cell?.tempLabel.text = Double(daily.dt).date(.day)
            cell?.highTempLabel.text = daily.temp.max.temp()
            cell?.lowTempLabel.text = daily.temp.min.temp()
            return cell
        })
    }
    
    private func createSnapshot(_ weatherModel: WeatherModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        snapshot.appendSections([.main])
        snapshot.appendItems(weatherModel.daily)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func update(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherData"] as? WeatherModel else { return }
        createSnapshot(weatherModel)
    }
    
}
