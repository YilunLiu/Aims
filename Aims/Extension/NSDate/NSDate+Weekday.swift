//
//  NSDate+LocalDescription.swift
//  Aims
//
//  Created by Yilun Liu on 12/22/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation

extension NSDate{
    
    func localDescriptionInWeekday() -> String {
        let weekDay = self.weekDay()
        return Weekday(rawValue: weekDay)!.description()
    }
    
    func weekDay() -> Int{
       return NSCalendar.currentCalendar().components([.Weekday], fromDate: self).weekday
    }
    
}