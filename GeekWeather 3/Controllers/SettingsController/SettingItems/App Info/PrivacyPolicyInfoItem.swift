//
//  PrivacyPolicyInfoItem.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import SafariServices

struct PrivacyPolicyInfoItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "Privacy Policy"
        cell.iconImageView.image = UIImage(named: "privacy-policy")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let url = URL(string: "https://bycyril.com/privacy-policy")!
        let sf = SFSafariViewController(url: url)
        vc.present(sf, animated: true, completion: nil)
    }
    
}
