//
//  CVCalendarWeekday.swift
//  CVCalendar Demo
//
//  Created by Eugene Mozharovsky on 15/04/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import Foundation

@objc public enum CVCalendarWeekday: Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
    
    func description() -> String{
        switch (self){
        case .Sunday: return "Sunday"
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        }
    }
}