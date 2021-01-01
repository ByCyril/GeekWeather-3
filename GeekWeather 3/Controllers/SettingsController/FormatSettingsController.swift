//
//  FormatSettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class FormatSettingsController: UITableViewController {
    
    @IBOutlet var scaleSelector: UISegmentedControl!
    @IBOutlet var unitSelector: UISegmentedControl!
    @IBOutlet var hourSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleSelector.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "Temperature")
        unitSelector.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "Units")
        hourSwitch.isOn = UserDefaults.standard.bool(forKey: "is24Hour")
    }
    
    @IBAction func changeScale(_ sender: UISegmentedControl) {
        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "Temperature")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
    
    @IBAction func changeUnits(_ sender: UISegmentedControl) {
        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "Units")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
    
    @IBAction func militaryTime(_ sender: UISwitch) {
        UserDefaults.standard.setValue(sender.isOn, forKey: "is24Hour")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
}
