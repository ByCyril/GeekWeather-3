//
//  DesignerInfoItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/21/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

struct DesignerInfoItem: SettingItem {
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "Designer"
        cell.iconImageView.image = UIImage(named: "44")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let dc = StoryboardManager.main().instantiateViewController(withIdentifier: "DesignerController")
        vc.show(dc, sender: vc)
    }
    
}
