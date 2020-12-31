//
//  SystemSettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SystemSettingsConroller: UITableViewController {
    
    @IBOutlet weak var hapticToggle: UISwitch!
    @IBOutlet weak var themeSelector: UISegmentedControl!
    
    let isHapticDisabled = UserDefaults.standard.bool(forKey: "DisableHaptic")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hapticToggle.isOn = !isHapticDisabled
    }
    
    @IBAction func toggleHapticFeedback(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "DisableHaptic")
    }
    
    @IBAction func changeAppearance(_ sender: UISegmentedControl) {
    }
    
}
