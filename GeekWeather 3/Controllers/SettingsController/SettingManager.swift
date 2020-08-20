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

final class SettingManager {
    
    var sections = [SectionItem]()
    var cells = [CellType]()
    
    init() {
        sections = [AppInfoSection(), AppSettingSection()]
        cells = [CellType(cell: SettingsTableViewCell.self, id: "cell")]
    }
    
    func cellRegistration(to tableView: UITableView) {
        for cell in cells {
            tableView.register(cell.cell, forCellReuseIdentifier: cell.id)
        }
    }
}

final class AppSettingSection: SectionItem {
    var title: String = "App Setting"
    
    var cells: [SettingItem]
    
    init() {
        cells = [AppIconSettingItem(), UnitSelectorItem()]
    }
}

final class AppInfoSection: SectionItem {
    var title: String = "App Info"
    
    var cells: [SettingItem]
    
    init() {
        cells = [AboutSettingItem(),
                 DeveloperInfoItem(),
                 WeatherDataInfoItem(),
                 PrivacyPolicyInfoItem()]
    }
}

struct CellType {
    var cell: UITableViewCell.Type
    var id: String
}
