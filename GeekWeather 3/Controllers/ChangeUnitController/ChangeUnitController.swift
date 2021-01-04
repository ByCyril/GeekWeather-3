//
//  ChangeUnitController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class ChangeUnitController: UITableViewController {
    
    @IBOutlet var segmentController: UISegmentedControl!
    
    private let selectedUnit = UserDefaults.standard.string(forKey: "Unit")
    
    private var selection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedUnit == "metric" {
            segmentController.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func didChangeUnits(_ sender: UISegmentedControl) {
        selection = ["imperial", "metric"][sender.selectedSegmentIndex]
        UserDefaults.standard.setValue(selection, forKey: "Unit")
    }
    
    deinit {
        if !selection.isEmpty && selection != selectedUnit {
            NotificationCenter.default.post(name: Notification.Name("UnitChange"), object: selection)
        }
        Mocks.reclaimedMemory(self)
    }
}
