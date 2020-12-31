//
//  AboutSettingItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

struct AboutSettingItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.iconImageView.image = UIImage(named: "geekweather")
        cell.titleLabel.text = "App Version"
        cell.detailLabel.text = "3.0"
        cell.selectionStyle = .none
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {

    }
}
