//
//  Array+Extension.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/21/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

extension Array {
    @discardableResult
    mutating func remove<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}
