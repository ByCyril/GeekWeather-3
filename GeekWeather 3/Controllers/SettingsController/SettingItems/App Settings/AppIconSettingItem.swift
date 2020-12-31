//
//  AppIconSettingItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class AppIconSettingItem: SettingItem {
    
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.iconImageView.image = UIImage(named: "change-app-icon")
        cell.titleLabel.text = "Change App Icon"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let main = MainViewController()
        vc.present(main, animated: true, completion: nil)
    }
}

