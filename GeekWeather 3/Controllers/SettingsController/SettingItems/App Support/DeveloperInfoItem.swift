//
//  DeveloperInfoItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import SafariServices

struct DeveloperInfoItem: SettingItem {
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "Developer"
        cell.iconImageView.image = UIImage(named: "boy")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let dc = StoryboardManager.main().instantiateViewController(withIdentifier: "DeveloperController")
        vc.show(dc, sender: vc)
    }
    
}
