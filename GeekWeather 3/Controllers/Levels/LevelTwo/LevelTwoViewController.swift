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
}

enum Section {
    case main
}

final class LevelTwoViewController: BaseView, UITableViewDelegate, UITableViewDataSource {
   
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
    
    override func animate() {
        dailyTableView.visibleCells.forEach { (cell) in
            cell.alpha = 0
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 150, 0)
            cell.layer.transform = transform
            
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    private func tableViewSetup() {
        dailyTableView.backgroundView?.backgroundColor = .clear
        dailyTableView.backgroundColor = .clear
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        dailyTableView.register(UINib(nibName: "LevelTwoCellView", bundle: .main), forCellReuseIdentifier: "cell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LevelTwoCellView
        cell?.backgroundColor = .clear
        
        let daily = weatherModel!.daily[indexPath.row]
        
        if indexPath.row == 0 {
            cell?.dayLabel.text = "Today"
        } else {
            cell?.dayLabel.text = Double(daily.dt).date(.day)
        }
        
        cell?.iconView.image = UIImage(named: daily.weather.first!.icon)
        cell?.highTempLabel.text = daily.temp.max.temp()
        cell?.lowTempLabel.text = daily.temp.min.temp()
        return cell!
    }
    
    override func update(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
        
        dailyTableView.reloadData()
    }
    
}
