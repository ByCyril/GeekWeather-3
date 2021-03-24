//
//  SettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SettingsController: UITableViewController {
    
    private var settingManager: SettingManagerProtocol
    
    init(_ settingManager: SettingManagerProtocol = SettingManager()) {
        self.settingManager = settingManager
        super.init(style: .insetGrouped)
        tableView.estimatedRowHeight = 50
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
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle.fill"), style: .plain, target: self, action: #selector(dismissController))
        barButton.tintColor = .label
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if settingManager.sections.count - 1 == section {
            return "Developed and Designed by Cyril © 2017 - 2021"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .label
        headerView.textLabel?.font = GWFont.AvenirNext(style: .Medium, size: 12)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        footerView.textLabel?.textColor = .label
        footerView.textLabel?.font = GWFont.AvenirNext(style: .Medium, size: 12)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingManager.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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
        Mocks.reclaimedMemory(self)
    }
}
