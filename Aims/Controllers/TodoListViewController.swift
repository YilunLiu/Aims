//
//  TodoListViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/17/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Parse
import CocoaLumberjackSwift

class TodoListViewController: UITableViewController, TaskItemDelegate {

    let todayMidnigt = NSDate.todayMidnight()
    let secInADay = 3600 * 24
    let todayWeekday = NSDate().weekDay()
    let sectionNum = 9
    
    var taskItems = [Int: [TaskItem]]()
    var taskItemService = TaskItemService()
    var includeComplete = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .SingleLine
        self.tableView.allowsMultipleSelection = false
        self.startUpdate(fromInternet: false, includeComplete: self.includeComplete)
        self.navigationItem.title = "Todo List"
        self.tableView.tableFooterView = UIView(frame: CGRectZero) // remove extra cell seperators
    }
    
    func startUpdate(fromInternet fromInternet: Bool, includeComplete include:Bool){
        
        self.taskItemService.fetchTaskItems(indays: 14, forUser: PFUser.currentUser()!, fromInternet: fromInternet, includeComplete: include)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .start(
                Observer<[TaskItem],NSError>(
                    failed: {
                        error in
                        self.displayError(error)
                    },
                    completed: nil,
                    interrupted: nil,
                    next: {
                        taskItems in
                        self.groupTaskItemsRespectToDays(taskItems)
                        self.tableView.reloadData()
                    }))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNum
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskItems = self.taskItems[section] else {
            return 0
        }
        return taskItems.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            switch (section){
            case 0: return "Past due"
            case 1: return "Today"
            case 2: return "Tomorrow"
            case sectionNum-1: return "In two weeks"
            default:
                let dueDate = self.taskItems[section]!.first!.due
                return dueDate.localDescriptionInWeekday() + " " + dueDate.dateString()
            }
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 20.0
        } else {
            return 0.0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskItemCell", forIndexPath: indexPath) as! TaskItemCell
        let taskItem = self.taskItems[indexPath.section]![indexPath.row]
        cell.titleLabel.text = taskItem.title
        if taskItem.due.isMidnight(){
            cell.timeLabel.text = taskItem.due.dateString()
        } else {
            cell.timeLabel.text = taskItem.due.timeString()
        }
        cell.setChecked(taskItem.isCompleted)
        
        
        return cell
    }
    

    
    // MARK: - UITableViewDelegate 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let taskItem = self.taskItems[indexPath.section]![indexPath.row]
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("TaskDetailViewController") as! TaskDetailViewController
        detailVC.taskItem = taskItem
        detailVC.taskItemDelegate = self
        self.taskItems[indexPath.section]!.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle){
        case .Delete:
            let taskItem = self.taskItems[indexPath.section]![indexPath.row]
            taskItem.unpinInBackground()
//            taskItem.deleteEventually()
            self.taskItems[indexPath.section]!.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default: break
        }
    }
    
    
    // MARK: - StoryBoard
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch(identifier){
        case "AddTaskItem":
            if let destinationVC = destinationVC as? TaskDetailViewController{
                destinationVC.taskItemDelegate = self
            }
        default: break
        }
        
    }
    
    
    // MARK: - TaskItemDelegate
    func didAddTaskItem(taskItem: TaskItem) {
        let indexPath = findIndexPathFor(taskItem)
        self.taskItems[indexPath.section]?.insert(taskItem, atIndex: indexPath.row)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
    }
    
    func didUpdateTaskItem(taskItem: TaskItem) {
        let indexPath = findIndexPathFor(taskItem)
        self.taskItems[indexPath.section]?.insert(taskItem, atIndex: indexPath.row)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    // MARK: - Target & Action
    
    @IBAction func checkboxPressed(sender: UIButton) {
        let touchPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(touchPoint)
        let taskItem = self.taskItems[indexPath!.section]![indexPath!.row]
        taskItem.isCompleted = !taskItem.isCompleted
        let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! TaskItemCell
        cell.setChecked(taskItem.isCompleted)
        taskItem.pinInBackground()
//        taskItem.saveEventually()
        
        DDLogInfo("\(indexPath) is pressed")
    }
    
    @IBAction func filterPressed(sender: AnyObject) {
       
        let filterActionString = self.includeComplete ? "Hide Completed" : "Show Completed"

        let alertController = UIAlertController(title: "Filter", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let filterCompleteAction = UIAlertAction(title: filterActionString, style: UIAlertActionStyle.Default, handler: {
            action in
            self.includeComplete = !self.includeComplete
            self.startUpdate(fromInternet: false, includeComplete: self.includeComplete)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(filterCompleteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Helper
    
    private func groupTaskItemsRespectToDays(taskItems: [TaskItem]){
        self.taskItems.removeAll()
        // Assume taskItems is sorted
        self.taskItems[0] = [TaskItem]() // 0 index for past due
        for taskItem in taskItems{
            let section = sectionForDate(taskItem.due)
            if self.taskItems[section] == nil {
                self.taskItems[section] = [TaskItem]()
            }
            self.taskItems[section]?.append(taskItem)
        }
    }
    
    
    private func sectionForTask(taskItem: TaskItem) -> Int {
        return sectionForDate(taskItem.due)
    }
    
    private func daysSinceToday(date:NSDate) -> Int{
        var timeDiff = date.timeIntervalSinceDate(todayMidnigt)
        if timeDiff < 0{
            timeDiff -= Double(secInADay)
        }
        return Int(timeDiff)/secInADay
    }
    
    private func sectionForDate(date: NSDate) -> Int {
        var diffinDays = self.daysSinceToday(date)
        if diffinDays < 0{
            diffinDays = 0
        } else if diffinDays > sectionNum - 2{
            diffinDays = sectionNum - 1
        } else {
            diffinDays = diffinDays + 1
        }
        return diffinDays
        
    }
    
    private func findIndexPathFor(taskItem: TaskItem) -> NSIndexPath{
        let section = self.sectionForTask(taskItem)
        var index = 0
        if self.taskItems[section] == nil {
            self.taskItems[section] = [TaskItem]()
        }
        for (i, taskItemB) in (self.taskItems[section]?.enumerate())! {
            let timeDiff = taskItem.due.timeIntervalSinceDate(taskItemB.due)
            if timeDiff == 0{
                if taskItem.title < taskItemB.title{
                    break
                }
            }
            else if timeDiff < 0 {
                break
            }
            index++
        }
        return NSIndexPath(forRow: index, inSection: section)
    }
    
    

    
}
