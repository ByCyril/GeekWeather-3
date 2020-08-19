//
//  SettingCellFactory.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

protocol SettingCellFactory {
    var cellHeight: CGFloat { get }
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func performSelector(_ vc: UIViewController)
}
