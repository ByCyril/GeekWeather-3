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
    @IBOutlet weak var pagingToggle: UISwitch!
    @IBOutlet weak var scrollAnimationToggle: UISwitch!
    
    let isHapticDisabled = UserDefaults.standard.bool(forKey: "DisableHaptic")
    let scrollAnimation = UserDefaults.standard.bool(forKey: "ScrollAnimationToggle")
    let pagingAnimation = UserDefaults.standard.bool(forKey: "PagingAnimationToggle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticToggle.isOn = !isHapticDisabled
        scrollAnimationToggle.isOn = !scrollAnimation
        pagingToggle.isOn = !pagingAnimation
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Regular, size: 17)]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .label
        headerView.textLabel?.font = GWFont.AvenirNext(style: .Medium, size: 12)
    }
    
    @IBAction func toggleHapticFeedback(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "DisableHaptic")
    }
    
    @IBAction func pagingEnabledToggle(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "PagingAnimationToggle")
        NotificationCenter.default.post(name: Notification.Name("PagingAnimationToggle"), object: nil)
    }
    
    @IBAction func turnOffScrollAnimation(_ sender: UISwitch) {
        UserDefaults.standard.setValue(!sender.isOn, forKey: "ScrollAnimationToggle")
    }
    
    deinit {
        Mocks.reclaimedMemory(self)
    }
}
