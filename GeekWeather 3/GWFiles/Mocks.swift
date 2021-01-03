//
//  Mocks.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

protocol MockErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct MockError: MockErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}

final class Mocks {
    
    static func mockedResponse() -> Data? {
        guard let file = Bundle.main.path(forResource: "preview", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: file)
        let data = try? Data(contentsOf: url, options: .mappedIfSafe)

        if UserDefaults.standard.bool(forKey: "ToggleMockedResponse") {
            return data
        }
        
        return data
    }
    
    static func mockError() -> Error? {
        let error = MockError(title: "Error", description: "Could not connect to network", code: 101)
        
        if UserDefaults.standard.bool(forKey: "ToggleMockError") {
            return error
        }
        
        return nil
    }
}
