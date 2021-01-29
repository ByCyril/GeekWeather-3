//
//  CusstomAPIKey.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/28/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

struct CustomAPIKey: SettingItem {
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "Custom API Key"
        cell.iconImageView.image = UIImage(named: "key")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let customAPIController = StoryboardManager.settings().instantiateViewController(withIdentifier: "CustomAPIController")
        customAPIController.title = "Custom API Key"
        vc.show(customAPIController, sender: vc)
    }
    
    
}
