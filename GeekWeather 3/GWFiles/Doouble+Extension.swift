//
//  Doouble+Extension.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation
import GWFoundation

extension Double {
    func kelvinToSystemFormat() -> String {
        let measure = UserDefaults.standard.integer(forKey: "Temperature")
        
        if measure == 0 {
            return self.temp(" K")
        } else if measure == 1 {
            return ((self - 273.15) * (9.0/5.0) + 32).temp()
        } else {
            return (self - 273.15).temp()
        }
    }
    
    func mToSystemFormat() -> String {
        let measure = UserDefaults.standard.integer(forKey: "Units")
        
        if measure == 0 {
            return self.stringRound() + "m"
        } else if measure == 1 {
            return (self / 1609).stringRound() + " mi"
        } else {
            return (self / 1000).stringRound() + " km"
        }
    }
    
    func msToSystemFormat() -> String {
        let measure = UserDefaults.standard.integer(forKey: "Units")
        
        if measure == 0 {
            return self.stringRound() + " m/s"
        } else if measure == 1 {
            return (self * 2.23694).stringRound() + " mph"
        } else {
            return (self * 3.6).stringRound() + " km/h"
        }
    }
    
    func convertHourTime() -> String {
        let is24 = UserDefaults.standard.bool(forKey: "is24Hour")
        return is24 ? self.date(.mHour) : self.date(.hour)
    }
    
    func convertTime() -> String {
        let is24 = UserDefaults.standard.bool(forKey: "is24Hour")
        return is24 ? self.date(.mtime) : self.date(.time)
    }
}
