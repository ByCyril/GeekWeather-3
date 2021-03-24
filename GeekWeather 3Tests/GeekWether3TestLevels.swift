//
//  GeekWether3TestLevels.swift
//  GeekWeather 3Tests
//
//  Created by Cyril Garcia on 3/23/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import XCTest
@testable import GeekWeather

class GeekWether3TestLevels: XCTestCase {

    func testLevelOne() {
        
        let bundle = Bundle(for: self.classForCoder)
        
        let levelOne = LevelOneViewController(frame: .zero, bundle)
        let mock = Mocks.mock()
        let mockNotification = NSNotification(name: .init(""), object: nil, userInfo: ["weatherModel": mock])
        
        levelOne.didRecieve(from: mockNotification)
        XCTAssertEqual(levelOne.tempLabel.text, "71°")
        
    }
}
