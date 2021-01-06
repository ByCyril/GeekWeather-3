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
    @IBOutlet weak var scrollAnimationToggle: UISwitch!
    
    let isHapticDisabled = UserDefaults.standard.bool(forKey: "DisableHaptic")
    let theme = UserDefaults.standard.string(forKey: "Theme")
    let scrollAnimation = UserDefaults.standard.bool(forKey: "ScrollAnimationToggle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticToggle.isOn = !isHapticDisabled
        scrollAnimationToggle.isOn = !scrollAnimation
        
        if theme == "System-" {
            themeSelector.selectedSegmentIndex = 0
        } else if theme == "Light-" {
            themeSelector.selectedSegmentIndex = 1
        } else if theme == "Dark-" {
            themeSelector.selectedSegmentIndex = 2
        }
        
    }
    
    @IBAction func toggleHapticFeedback(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "DisableHaptic")
    }
    
    @IBAction func changeAppearance(_ sender: UISegmentedControl) {
        let vals = ["System-", "Light-", "Dark-"][sender.selectedSegmentIndex]
        UserDefaults.standard.setValue(vals, forKey: "Theme")
    }
    
    @IBAction func turnOffScrollAnimation(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "ScrollAnimationToggle")
    }
    
    deinit {
        Mocks.reclaimedMemory(self)
    }
}
