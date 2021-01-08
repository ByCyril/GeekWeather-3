//
//  DeveloperController.swift
//  
//
//  Created by Cyril Garcia on 12/22/20.
//

import UIKit
import SafariServices
import MessageUI

final class DeveloperController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var detailedDescrLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var linkedinLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Developer"
        createDynamicType()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
    private func createDynamicType() {
        [descrLabel, detailedDescrLabel, twitterLabel, linkedinLabel, websiteLabel, emailLabel].forEach { (label) in
            label?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: label!.font)
            label?.adjustsFontForContentSizeCategory = true
        }
        
        nameLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: nameLabel!.font)
        nameLabel.adjustsFontForContentSizeCategory = true
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            open("https://twitter.com/_ByCyril")
        } else if indexPath.section == 1 && indexPath.row == 1 {
            open("https://www.linkedin.com/in/bycyril/")
        } else if indexPath.section == 1 && indexPath.row == 2 {
            open("https://bycyril.com")
        } else if indexPath.section == 1 && indexPath.row == 3 {
            sendEmail()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["garciacy@bycyril.com"])
            mail.setMessageBody("<p>Mail from GeekWeather 3</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func open(_ urlStr: String) {
        let url = URL(string: urlStr)!
        let sf = SFSafariViewController(url: url)
        present(sf, animated: true, completion: nil)
    }
    
    deinit {
        Mocks.reclaimedMemory(self)
    }
}
