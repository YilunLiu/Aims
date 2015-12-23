//
//  NSDate+DateFromComponents.swift
//  Aims
//
//  Created by Yilun Liu on 12/18/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation

extension NSDate{
    
    class func dateFromComponents(components: NSDateComponents) -> NSDate{
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
}