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
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Developer"
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 3 {
            open("https://bycyril.com")
        } else if indexPath.section == 1 && indexPath.row == 0 {
            open("https://twitter.com/_ByCyril")
        } else if indexPath.section == 1 && indexPath.row == 1 {
            open("https://instagram.com/_bycyril")
        } else if indexPath.section == 1 && indexPath.row == 2 {
            open("https://www.linkedin.com/in/bycyril/")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 50
        }
    }

    private func open(_ urlStr: String) {
        let url = URL(string: urlStr)!
        let sf = SFSafariViewController(url: url)
        present(sf, animated: true, completion: nil)
    }
    
    deinit {
        reclaimedMemory()
    }
    
    func reclaimedMemory(_ fileName: String = #file,
                         _ funcName: String = #function,
                         _ lineNumber: Int = #line) {
        
        Swift.print("")
        Swift.print("##########")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS:",String(describing: type(of: self)))
        Swift.print("##########")
        Swift.print("")
    }
}
