//
//  Date+Extension.swift
//  NVFoundation
//
//  Created by Cyril Garcia on 1/5/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import Foundation

extension Date {
    
    public func timeInterval(between date2: Date) -> Double {
        let date1 = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var components1 = NSCalendar.current.dateComponents([.hour, .minute], from: date1)
        let components2 = NSCalendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: date2 as Date)
        
        components1.year = components2.year;
        components1.month = components2.month;
        components1.day = components2.day;
        
        let date3 = NSCalendar.current.date(from: components1)
        
        let timeIntervalInMinutes = date3!.timeIntervalSince(date2 as Date)/60
        
        if timeIntervalInMinutes < 0 {
            return timeIntervalInMinutes * -1
        }
        
        return timeIntervalInMinutes
    }
}
