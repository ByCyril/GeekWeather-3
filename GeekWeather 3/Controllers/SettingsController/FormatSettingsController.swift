//
//  FormatSettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import WidgetKit

final class FormatSettingsController: UITableViewController {
    
    @IBOutlet var scaleSelector: UISegmentedControl!
    @IBOutlet var unitSelector: UISegmentedControl!
    @IBOutlet var hourSwitch: UISwitch!
    
    let tempSetting = sharedUserDefaults?.integer(forKey: "Temperature") ?? 0
    let unitSetting = sharedUserDefaults?.integer(forKey: "Units") ?? 0
    let hourSetting = sharedUserDefaults?.bool(forKey: "is24Hour") ?? false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleSelector.selectedSegmentIndex = tempSetting
        unitSelector.selectedSegmentIndex = unitSetting
        hourSwitch.isOn = hourSetting
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Regular, size: 17)]
    }
    
    @IBAction func changeScale(_ sender: UISegmentedControl) {
        sharedUserDefaults?.setValue(sender.selectedSegmentIndex, forKey: "Temperature")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
    
    @IBAction func changeUnits(_ sender: UISegmentedControl) {
        sharedUserDefaults?.setValue(sender.selectedSegmentIndex, forKey: "Units")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
    
    @IBAction func militaryTime(_ sender: UISwitch) {
        sharedUserDefaults?.setValue(sender.isOn, forKey: "is24Hour")
        NotificationCenter.default.post(name: Notification.Name("UpdateValues"), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .label
        headerView.textLabel?.font = GWFont.AvenirNext(style: .Medium, size: 12)
    }
    
    deinit {
        if scaleSelector.selectedSegmentIndex != tempSetting || unitSelector.selectedSegmentIndex != unitSetting || hourSwitch.isOn != hourSetting {
            WidgetCenter.shared.reloadAllTimelines()
        }
        Mocks.reclaimedMemory(self)
    }
}
