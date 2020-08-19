//
//  AppIconSettingCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class AppIconSettingCell: SettingItem {
    
    var cellHeight: CGFloat = 100
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.iconImageView.image = UIImage(named: "geekweather")
        cell.titleLabel.text = "Change App Icon"
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let main = MainViewController()
        vc.present(main, animated: true, completion: nil)
    }
}

