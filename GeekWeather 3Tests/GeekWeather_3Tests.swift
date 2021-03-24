//
//  GeekWeather_3Tests.swift
//  GeekWeather 3Tests
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import XCTest
@testable import GeekWeather

class GeekWeather_3Tests: XCTestCase {

    func testSettingsController() {
        
        let settingsController = SettingsController()
        
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 0), 3)
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 1), 3)
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 2), 3)
        
    }

    class MockSetttingsManager: SettingManagerProtocol {
        var sections: [SectionItem]
        
        var cells: [CellType]
        
        init() {
            sections = [MockSectionItem("FirstItem"),MockSectionItem("SecondItem"),MockSectionItem("ThirdItem")]
            cells = [CellType(cell: UITableViewCell.self, id: "cell")]
        }
        
        func cellRegistration(to tableView: UITableView) {
            cells.forEach { (cell) in
                tableView.register(cell.cell, forCellReuseIdentifier: cell.id)
            }
        }
    }
    
    class MockSectionItem: SectionItem {
        var title: String
        var cells: [SettingItem] = [MockSettingItem()]
        
        init(_ title: String) {
            self.title = title
        }
    }
    
    struct MockSettingItem: SettingItem {
        var cellHeight: CGFloat = 50
        
        func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "MockCell"
            return cell
        }
        
        func performSelector(_ vc: UIViewController) { }
            
    }
    
    func testSettingsManager() {
        let mockSettingsManager = MockSetttingsManager()
        let settingsController = SettingsController(mockSettingsManager)
        
        for (i, title) in ["FirstItem","SecondItem","ThirdItem"].enumerated() {
            XCTAssertEqual(settingsController.tableView(settingsController.tableView, titleForHeaderInSection: i), title)
        }
        
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 1), 1)
        XCTAssertEqual(settingsController.tableView.numberOfRows(inSection: 2), 1)
        XCTAssertEqual(settingsController.tableView.numberOfSections, 3)
        
    }
    

}
