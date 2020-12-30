//
//  ToggleOnboarding.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/29/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class ToggleOnboarding: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = "Show Onboarding"
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Warning!", message: "Please use with caution. Some things might break when triggering this command. Feel free to ask the developer for more info about developer tools", preferredStyle: .actionSheet)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            UserDefaults.standard.setValue(false, forKey: "ExistingUser")
            self.finishedAlert(vc)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(cancel)
        
        vc.present(alert, animated: true)
    }
    
    func finishedAlert(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Done", message: "Kill and relaunch the app", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        vc.present(alert, animated: true)
    }
}
