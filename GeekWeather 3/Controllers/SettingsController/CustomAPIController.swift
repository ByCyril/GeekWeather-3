//
//  CustomAPIController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/28/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class CustomAPIController: UIViewController {
    
    @IBOutlet var apiField: UITextField!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveKey))
        barButton.tintColor = .label
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc
    func saveKey() {
        loadingView.startAnimating()
        if let key = apiField.text {
            NetworkLayer().validate(key) { [weak self] (results) in
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                    if let res = results {
                        self?.errorAlert(res)
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
}
