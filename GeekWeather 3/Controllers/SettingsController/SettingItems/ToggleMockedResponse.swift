//
//  ToggleMockedResponse.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/29/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class ToggleMockedResponse: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = "Show Dummy Data"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Mocked Response", message: "Turn on Mocked Response", preferredStyle: .actionSheet)
        let mockedReponse = UserDefaults.standard.bool(forKey: "ToggleMockedResponse")
        
        let enable = UIAlertAction(title: "Turn On", style: .default) { (_) in
            UserDefaults.standard.setValue(true, forKey: "ToggleMockedResponse")
            self.finishedAlert(vc)
        }
        
        let disable = UIAlertAction(title: "Turn Off", style: .default) { (_) in
            UserDefaults.standard.setValue(false, forKey: "ToggleMockedResponse")
            self.finishedAlert(vc)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(mockedReponse ? disable : enable )
        alert.addAction(cancel)
        
        vc.present(alert, animated: true) {
            
        }
    }
    
    func finishedAlert(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Done", message: "Kill and relaunch the app", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
}
