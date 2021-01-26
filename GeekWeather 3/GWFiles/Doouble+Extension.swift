//
//  Doouble+Extension.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import Foundation

extension Double {
    func kelvinToSystemFormat(_ toF: Bool = false) -> String {
        if toF {
            return ((self - 273.15) * (9.0/5.0) + 32).temp()
        }
        
        guard let measure = sharedUserDefaults?.integer(forKey: SharedUserDefaults.Keys.Temperature) else { return ((self - 273.15) * (9.0/5.0) + 32).temp() }
        
        if measure == 0 {
            return ((self - 273.15) * (9.0/5.0) + 32).temp()
        } else if measure == 1 {
            return (self - 273.15).temp()
        } else {
            return self.temp("K")
        }
    }
    
    func mToSystemFormat() -> String {
        guard let measure = sharedUserDefaults?.integer(forKey: SharedUserDefaults.Keys.Units) else { return self.stringRound() + "m" }
        
        if measure == 0 {
            return self.stringRound() + "m"
        } else if measure == 1 {
            return (self / 1609).stringRound() + "mi"
        } else {
            return (self / 1000).stringRound() + "km"
        }
    }
    
    func msToSystemFormat() -> String {
        
        guard let measure = UserDefaults(suiteName: SharedUserDefaults.suiteName)?.integer(forKey: SharedUserDefaults.Keys.Units) else { return self.stringRound() + "m/s" }
        
        if measure == 0 {
            return self.stringRound() + "m/s"
        } else if measure == 1 {
            return (self * 2.23694).stringRound() + "mph"
        } else {
            return (self * 3.6).stringRound() + "km/h"
        }
    }
    
    func convertHourTime() -> String {
        if let is24 = sharedUserDefaults?.bool(forKey: SharedUserDefaults.Keys.is24Hour) {
            return is24 ? self.date(.mHour) : self.date(.hour)
        } else {
            return self.date(.hour)
        }
    }
    
    func convertTime() -> String {
        if let is24 = sharedUserDefaults?.bool(forKey: SharedUserDefaults.Keys.is24Hour) {
            return is24 ? self.date(.mtime) : self.date(.time)
        } else {
            return self.date(.time)
        }
    }
}
