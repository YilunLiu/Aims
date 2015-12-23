//
//  TaskItemService.swift
//  Aims
//
//  Created by Yilun Liu on 12/22/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import CocoaLumberjackSwift

class TaskItemService {
    
    
    init(){
    }
    
    func fetchTaskItems(indays days: Int, forUser user:PFUser, fromInternet: Bool, includeComplete include: Bool) -> SignalProducer<[TaskItem], NSError> {
        let (taskItemsSignalProducer, taskItemsObserver) = SignalProducer<[TaskItem], NSError>.buffer()
        
        let localQuery = queryForTaskItems(indays: days, forUser: user, includeComplete: include)
        localQuery.fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                taskItemsObserver.sendNext(objects as! [TaskItem])
                DDLogInfo("Successfully retrived taskitems for user: \(user) from localstore")
                if !fromInternet{
                    taskItemsObserver.sendCompleted()
                }
            } else {
                DDLogError("An Error Occured when loading from local store: \(error)")
                if !fromInternet{
                    taskItemsObserver.sendFailed(error!)
                }
            }
        }
        
        
        if fromInternet{
            let internetQuery = queryForTaskItems(indays: days, forUser: user, includeComplete: include)
            internetQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    taskItemsObserver.sendNext(objects as! [TaskItem])
                    DDLogInfo("Successfully retrived taskitems for user: \(user) from internet")
                    taskItemsObserver.sendCompleted()
                    
                } else {
                    DDLogError("An Error Occurred when loading from Internet: \(error)")
                    taskItemsObserver.sendFailed(error!)
                }
                
            }
        }
        
        return taskItemsSignalProducer
        
        
    }
    
    private func queryForTaskItems(indays days: Int, forUser user:PFUser, includeComplete include: Bool)->PFQuery{
        var query = TaskItem.query()!
        let today = NSDate.todayMidnight()
        let dateInFuture = NSDate(timeInterval: Double(3600*24*days), sinceDate: today)
        query.whereKey("due", lessThan: dateInFuture)
        query.whereKey("owner", equalTo: user)
        query.whereKey("isCompleted", equalTo: false)

        
        if include {
            let secondQuery = TaskItem.query()!
            secondQuery.whereKey("due", greaterThanOrEqualTo: today)
            secondQuery.whereKey("due", lessThan: dateInFuture)
            secondQuery.whereKey("owner", equalTo: user)
            secondQuery.whereKey("isCompleted", equalTo: true)
            query = PFQuery.orQueryWithSubqueries([query, secondQuery])
        }
        
        query.orderByAscending("due")
        query.addAscendingOrder("title")
        return query
    }
}