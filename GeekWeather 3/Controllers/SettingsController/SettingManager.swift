//
//  SettingManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

protocol SectionItem {
    var title: String { get }
    var cells: [SettingItem] { get }
}

protocol SettingManagerProtocol {
    var sections: [SectionItem] { get }
    var cells: [CellType] { get }
    
    func cellRegistration(to tableView: UITableView)
}

final class SettingManager: SettingManagerProtocol {
    
    var sections = [SectionItem]()
    var cells = [CellType]()
    
    init() {
        sections = [AppSettingSection(), AppInfoSection(), AppSupprtSection()]
        cells = [CellType(cell: SettingsTableViewCell.self, id: "cell")]
    }
    
    func cellRegistration(to tableView: UITableView) {
        for cell in cells {
            tableView.register(cell.cell, forCellReuseIdentifier: cell.id)
        }
    }
}

final class DeveloperToolsSection: SectionItem {
    var title: String = "Developer Tools"
    
    var cells: [SettingItem]
    
    init() {
        cells = [ToggleMockedResponse(), ToggleOnboarding(), DeleteAllSearchItems(), ResetNumberCalls()]
    }
}

final class AppSettingSection: SectionItem {
    var title: String = "Setting"
    
    var cells: [SettingItem]
    
    init() {
        cells = [UnitSelectorItem(),
                 HapticFeedbackItem(),
                 CustomAPIKey()]
    }
}

final class AppInfoSection: SectionItem {
    var title: String = "Info"
    
    var cells: [SettingItem]
    
    init() {
        cells = [AboutSettingItem(),
                 WeatherDataInfoItem(),
                 PrivacyPolicyInfoItem()]
    }
}

final class AppSupprtSection: SectionItem {
    var title: String = "Support"
    
    var cells: [SettingItem]
    
    init() {
        cells = [HelpItem(),
                 DeveloperInfoItem(),
                 DesignerInfoItem()]
    }
    
}

struct CellType {
    var cell: UITableViewCell.Type
    var id: String
}
