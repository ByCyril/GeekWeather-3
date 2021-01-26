//
//  String+Extension.swift
//  NVFoundation
//
//  Created by Cyril Garcia on 1/5/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import CoreLocation
import Foundation

extension String {
    public func toCLLocation() -> CLLocation {
        let str = self.components(separatedBy: ",")
        let lat = CLLocationDegrees(exactly: Double(str[0])!)
        let long = CLLocationDegrees(exactly: Double(str[ 1])!)
        let location = CLLocation(latitude: lat!, longitude: long!)
        return location
    }
}
