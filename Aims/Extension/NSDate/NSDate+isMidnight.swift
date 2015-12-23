//
//  NSDate+isMidnight.swift
//  Aims
//
//  Created by Yilun Liu on 12/18/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation

extension NSDate {
    
    
    
    func isMidnight() -> Bool{
        let dateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: self)
        return dateComponents.hour == 0 && dateComponents.minute == 0
    }
    
    class func midNight() -> NSDate{
        let dateComponents = NSDateComponents()
        dateComponents.hour = 0
        dateComponents.minute = 0
        return NSDate.dateFromComponents(dateComponents)
    }
    
    class func todayMidnight() -> NSDate{
        let components = NSDateComponents.componentsFromDate(NSDate())
        components.hour = 0
        components.minute = 0
        return NSDate.dateFromComponents(components)
    }
    
}
