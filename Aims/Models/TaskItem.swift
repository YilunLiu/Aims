//
//  TodoItem.swift
//  Aims
//
//  Created by Yilun Liu on 12/16/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import Parse

class TaskItem: PFObject, PFSubclassing {

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "TaskItem"
    }
    
    // MARK: - instances variables
    
    var owner: PFUser {
        get{
            let owner: PFUser = objectForKey("owner") as! PFUser
            owner.fetchInBackground()
            return owner
        }
        set (newValue){
            setObject(newValue, forKey: "owner")
        }
    }
    
    var due: NSDate {
        get{
            return objectForKey("due") as! NSDate
        }
        set (newValue){
            setObject(newValue, forKey: "due")
        }
    }
    
    var title: String {
        get {
            return objectForKey("title") as! String
        }
        set (newValue){
            setObject(newValue, forKey: "title")
        }
    }
    
    var descriptionText: String{
        get {
            return objectForKey("description") as! String
        }
        set (newValue){
            setObject(newValue, forKey: "description")
        }
    }
    
    var priority: Priority{
        get{
            return Priority(rawValue: objectForKey("priority") as! Int)!
        }
        set (newValue){
            if newValue.rawValue <= Priority.High.rawValue &&
                newValue.rawValue >= Priority.Low.rawValue {
                    setObject(newValue.rawValue, forKey: "priority")
            }
        }
    }
    
    var isCompleted: Bool{
        get{
            return objectForKey("isCompleted") as! Bool
        }
        set (newValue){
            setObject(newValue, forKey: "isCompleted")
        }
    }
    
    
}
