//
//  NSDate+FormattedString.swift
//  Aims
//
//  Created by Yilun Liu on 12/22/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation

extension NSDate{
    
    func timeString() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.stringFromDate(self)
    }
    
    func dateString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.stringFromDate(self)
    }
    
}