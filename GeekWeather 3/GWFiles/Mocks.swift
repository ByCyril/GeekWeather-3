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
    
    static func mock() -> WeatherModel {
        let file = Bundle.main.path(forResource: "preview", ofType: "json")!
        let url = URL(fileURLWithPath: file)
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        
        let decode = JSONDecoder()
        let model = try! decode.decode(WeatherModel.self, from: data)
        
        let format = NetworkManager().formatData(response: model)
        return format
    }
    
    static func showMockedResponse() -> Bool {
        var config: [String: Bool]?
        if let infoPlistPath = Bundle.main.url(forResource: "Tests", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Bool] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }
        
        return config?["Show Mock"] ?? false
    }
    
    static func mockedResponse() -> Data? {
        guard let file = Bundle.main.path(forResource: "preview", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: file)
        let data = try? Data(contentsOf: url, options: .mappedIfSafe)
        
        if UserDefaults.standard.bool(forKey: "ToggleMockedResponse") {
            return data
        }
        
        return nil
    }
    
    static func mockError() -> Error? {
        let error = MockError(title: "Error", description: "Could not connect to network", code: 101)
        
        if UserDefaults.standard.bool(forKey: "ToggleMockError") {
            return error
        }
        
        return nil
    }
    
    
    static func reclaimedMemory(_ x: Any) {
        Swift.print("")
        Swift.print("##################################################")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS:",String(describing: type(of: x)))
        Swift.print("##################################################")
        Swift.print("")
    }
    
}
