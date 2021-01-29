//
//  AboutSettingItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var buildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

struct AboutSettingItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.iconImageView.image = UIImage(named: "geekweather")
        cell.titleLabel.text = "App Version"
        cell.detailLabel.text = (UIApplication.appVersion ?? "na") + " (βeta 4)"
        cell.selectionStyle = .none
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {

    }
}
