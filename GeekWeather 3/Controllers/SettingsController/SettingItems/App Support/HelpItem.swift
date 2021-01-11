//
//  HelpItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/8/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import SafariServices

struct HelpItem: SettingItem {
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "Help"
        cell.iconImageView.image = UIImage(named: "boy")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let sf = SFSafariViewController(url: URL(string: "https://bycyril.com/geekweather-help")!)
        vc.show(sf, sender: vc)
    }
    
}
