//
//  FeatureFlag.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

final class FeatureFlag {
    
    static func mockedResponse() -> Data? {
        guard let file = Bundle.main.path(forResource: "test", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: file)
        let data = try? Data(contentsOf: url, options: .mappedIfSafe)
        return data
    }
}
