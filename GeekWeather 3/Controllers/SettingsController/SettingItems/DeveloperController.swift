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
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        let exclusivePathFrame = view.convert(profileImageView.frame, to: bioTextView)
        
        let imageFrame = UIBezierPath(rect: CGRect(x: 0, y: 0, width: exclusivePathFrame.width , height: exclusivePathFrame.height))

        bioTextView.textContainer.exclusionPaths = [imageFrame]
        bioTextView.isScrollEnabled = false
        
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

    private func open(_ urlStr: String) {
        let url = URL(string: urlStr)!
        let sf = SFSafariViewController(url: url)
        present(sf, animated: true, completion: nil)
    }
}
