//
//  DeleteAllSearchItems.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/29/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class DeleteAllSearchItems: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Delete all Searched Items"
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Warning!", message: "Please use with caution. Some things might break when triggering this command. Feel free to ask the developer for more info about developer tools", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete All", style: .destructive) { (_) in
            PersistenceManager.shared.deleteAll()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}
