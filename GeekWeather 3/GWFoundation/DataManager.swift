//
//  DataManager.swift
//  NVFoundation
//
//  Created by Cyril Garcia on 8/1/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import Foundation

final public class DataManager {
    
    weak var delegate: NetworkManagerDelegate?
    
    public init() {}
    
    public func prepareWeather(_ data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(WeatherModel.self, from: data)
            delegate?.didFinishFetching(response)
        } catch {
            print(error.localizedDescription)
            delegate?.networkError(error)
        }
    }
}
