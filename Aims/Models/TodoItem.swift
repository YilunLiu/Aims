//
//  TodoItem.swift
//  Aims
//
//  Created by Yilun Liu on 12/16/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import Parse

class TodoItem: PFObject, PFSubclassing {

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "TodoItem"
    }
    
    
}
