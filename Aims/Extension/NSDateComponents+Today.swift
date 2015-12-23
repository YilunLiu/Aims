//
//  NSDateComponents+Today.swift
//  Aims
//
//  Created by Yilun Liu on 12/18/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation

extension NSDateComponents{
    
    class func today() -> NSDateComponents{
        return componentsFromDate(NSDate())
    }
    
    class func componentsFromDate(date: NSDate) -> NSDateComponents{
        return NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute], fromDate: date)
    }
}