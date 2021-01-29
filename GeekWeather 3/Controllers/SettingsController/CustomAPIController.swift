//
//  CustomAPIController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/28/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class CustomAPIController: UITableViewController {
    
    @IBOutlet var apiField: UITextField!
    @IBOutlet var currentAPIStatus: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        if sharedUserDefaults?.value(forKey: "") == nil {
            currentAPIStatus.text = "You are currently using the default API key."
        } else {
            currentAPIStatus.text = "You are currently using a custom API key."
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func saveKey() {
        loadingView.startAnimating()
        apiField.resignFirstResponder()
        if let key = apiField.text {
            NetworkLayer().validate(key) { [weak self] (results) in
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                    if let res = results {
                        self?.errorAlert(res)
                        self?.apiField.becomeFirstResponder()
                    } else {
                        self?.confirmationAlert(key)
                    }
                }
            }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            loadingView.stopAnimating()
        }
    }
    
    func errorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let back = UIAlertAction(title: "Back", style: .cancel)
        
        alert.addAction(back)
        present(alert, animated: true)
    }
    
    func confirmationAlert(_ key: String) {
        let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to use this API Key for your weather data?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
            sharedUserDefaults?.setValue(key, forKey: "CustomAPIKey")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self?.dismiss(animated: true)
        }
        
        let no = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
    
    @IBAction func restoreToDefault() {
        let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to restore to the default API key?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
            sharedUserDefaults?.removeObject(forKey: "CustomAPIKey")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self?.dismiss(animated: true)
        }
        
        let no = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
}
