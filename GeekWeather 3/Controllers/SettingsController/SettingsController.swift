//
//  SettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SettingsController: UITableViewController {
  
    private let settingManager = SettingManager()
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        settingManager.cellRegistration(to: tableView)
    }
    
    func initUI() {
        
        title = "Settings"
        navigationItem.titleView?.isAccessibilityElement = false
        
        let backButton = UIButton()
        backButton.isAccessibilityElement = true
        backButton.applyAccessibility(with: "Back", and: "Double tap to dismiss popup window", trait: .button)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.setRightBarButton(barButton, animated: true)
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .label
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingManager.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingManager.sections[indexPath.section].cells[indexPath.row].cellHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingManager.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingManager.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingManager.sections[indexPath.section].cells[indexPath.row].performSelector(self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingManager.sections[indexPath.section].cells[indexPath.row].createCell(in: tableView, for: indexPath)
    }
    
    
    deinit {
        reclaimedMemory()
    }
    
    func reclaimedMemory(_ fileName: String = #file,
                         _ funcName: String = #function,
                         _ lineNumber: Int = #line) {
        
        Swift.print("")
        Swift.print("##########")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS:",String(describing: type(of: self)))
        Swift.print("##########")
        Swift.print("")
    }
    
}
