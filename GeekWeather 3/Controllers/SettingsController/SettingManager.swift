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

final class AppSettingSection: SectionItem {
    var title: String = "App Setting"
    
    var cells: [SettingItem]
    
    init() {
        cells = [AppIconSettingCell()]
    }
}

final class AppInfoSection: SectionItem {
    var title: String = "App Info"
    
    var cells: [SettingItem]
    
    init() {
        cells = [AboutSettingCell(), DeveloperInfoCell()]
    }
}

final class SettingManager {
    
    var sections = [SectionItem]()
    
    init() {
        sections = [AppSettingSection(), AppInfoSection()]
    }
}
