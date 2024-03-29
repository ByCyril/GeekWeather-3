//
//  UnitSelectorItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

struct UnitSelectorItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "Formatting"
        cell.iconImageView.image = UIImage(named: "thermometer")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let uc = StoryboardManager.settings().instantiateViewController(withIdentifier: "ChangeUnitController")
        uc.title = "Formatting"
        vc.show(uc, sender: vc)
    }
    
}
