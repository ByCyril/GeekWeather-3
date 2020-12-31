//
//  HapticFeedbackItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

struct HapticFeedbackItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "System"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let hc = StoryboardManager.settings().instantiateViewController(withIdentifier: "HapticFeedbackSettings")
        hc.title = "System"
        vc.show(hc, sender: vc)
    }
    
}
