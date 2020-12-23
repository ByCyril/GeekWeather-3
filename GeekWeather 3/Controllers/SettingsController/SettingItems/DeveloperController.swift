//
//  DeveloperController.swift
//  
//
//  Created by Cyril Garcia on 12/22/20.
//

import UIKit
import SafariServices

final class DeveloperController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Developer"
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            open("https://bycyril.com")
        } else if indexPath.section == 1 && indexPath.row == 0 {
            open("https://twitter.com/_ByCyril")
        } else if indexPath.section == 1 && indexPath.row == 1 {
            open("https://instagram.com/_bycyril")
        } else if indexPath.section == 1 && indexPath.row == 2 {
            open("https://www.linkedin.com/in/bycyril/")
        }
        
    }

    private func open(_ urlStr: String) {
        let url = URL(string: urlStr)!
        let sf = SFSafariViewController(url: url)
        present(sf, animated: true, completion: nil)
    }
}
