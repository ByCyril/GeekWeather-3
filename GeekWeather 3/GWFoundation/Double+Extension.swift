//
//  String+Extension.swift
//  NVFoundation
//
//  Created by Cyril Garcia on 12/26/19.
//  Copyright © 2019 Cyril Garcia. All rights reserved.
//


import Foundation

public enum TimestampFormat: String {
    case halfDate = "E, MMM d"
    case fullDate = "EEEE, MMMM d, yyyy h:mm a"
    case time = "h:mma"
    case hour = "ha"
    case mHour = "H"
    case mtime = "H:mm"
    case day = "EEEE"
    case shortDay = "EE"
    case year = "yyyy"
    case truncFullDate = "MMM d, h a"
}

extension Double {

    public func temp(_ u: String = "°") -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal
        let temp = formatter.string(from: self.rounded() as NSNumber) ?? "NA"
        
        if temp == "-0" {
            return String(temp.dropFirst()) + u
        }
        
        return " " + temp + u
    }
    
    public func date(_ format: TimestampFormat, _ timezone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timezone ?? TimeZone.current
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        
        if format == .hour {
            return formattedDate.lowercased()
        } else {
            return formattedDate
        }
    }
    
    public func percentage(chop: Bool) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        if chop {
            let perc = formatter.string(from: self.rounded() as NSNumber) ?? "NA"
            return perc + "%"
        }
        
        let val = self * 100.0
        
        
        let perc = formatter.string(from: val.rounded() as NSNumber) ?? "NA"
        return perc + "%"
    }
    
    public func stringRound() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        
        let val = formatter.string(from: self as NSNumber) ?? "NA"
        return val
    }
}
