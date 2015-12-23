//
//  AddTodoViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/17/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import ReactiveCocoa
import CocoaLumberjackSwift
import Parse

protocol TaskItemDelegate {
    func didUpdateTaskItem(taskItem: TaskItem)
    func didAddTaskItem(taskItem: TaskItem)
}

class TaskDetailViewController: UITableViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var duedateLabel: UILabel!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var taskItem: TaskItem?
    var taskItemDelegate: TaskItemDelegate?
    var dateObserver: Observer<NSDate, NoError>!
    
    private var isNew: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Item Setting
        if self.taskItem == nil {
            isNew = true
            let taskItem = TaskItem()
            taskItem.title = ""
            taskItem.priority = Priority.Normal
            taskItem.descriptionText = ""
            taskItem.owner = PFUser.currentUser()!
            taskItem.isCompleted = false
            let components = NSDateComponents.today()
            components.hour = 0
            components.minute = 0
            taskItem.due = NSDate.dateFromComponents(components)
            self.taskItem = taskItem
            
            self.navigationItem.title = "Add"
        }
        

        
        // View Setting
        let tapGesture = UITapGestureRecognizer(target: self.view, action: "endEditing:")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        titleField.text = taskItem?.title
        descriptionTextView.text = taskItem?.descriptionText
        prioritySegment.selectedSegmentIndex = (taskItem?.priority.rawValue)!
        self.duedateLabel.text = self.dateLabelTextFromDate(taskItem!.due)
        

        // Signal Setting
        titleField.rac_textSignal().toSignalProducer().startWithNext{
            value in
            if let string = value as? String{
                self.taskItem!.title = string
            }
        }
        
        descriptionTextView.rac_textSignal().toSignalProducer().startWithNext{
            value in
            if let string = value as? String {
                self.taskItem!.descriptionText = string
            }
        }
        
        prioritySegment.rac_newSelectedSegmentIndexChannelWithNilValue(Priority.Normal.rawValue).toSignalProducer().startWithNext{
            value in
            self.taskItem!.priority = Priority(rawValue: value as! Int)!
            
        }
        
        let (dateSignal, dateObserver) = Signal<NSDate, NoError>.pipe()
        self.dateObserver = dateObserver
        dateSignal.observeNext{
            date in
            self.taskItem!.due = date
            self.duedateLabel.text = self.dateLabelTextFromDate(date)
        }
        
        dateObserver.sendNext(self.taskItem!.due)
        
        
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        // will remove from parent
        if parent == nil {
            if !isNew {
                self.taskItemDelegate?.didUpdateTaskItem(self.taskItem!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        
        switch(segue.identifier!){
            case "CanlendarPicker":
                let date = self.taskItem!.due
                let (signal, observer) = Signal<NSDateComponents, NoError>.pipe()
                signal.observe(Signal.Observer { event in
                    switch event {
                    case let .Next(next):
                        self.dateObserver.sendNext(NSDate.dateFromComponents(next))
                    case .Failed(_): break
                    case .Completed: break
                    case .Interrupted:
                        DDLogInfo("Interupted")
                        self.dateObserver.sendNext(date)
                    }
                })
                (destinationVC as! CalendarPickerViewController).date = self.taskItem!.due
                (destinationVC as! CalendarPickerViewController).parentObserver = observer
            
        default: break
        }
    }
    
    
    // MARK : - Target & Action
    @IBAction func compeletedPressed(sender: AnyObject) {
        self.taskItem!.pinInBackground()
//        self.taskItem!.saveEventually()
        if isNew {
            self.taskItemDelegate?.didAddTaskItem(self.taskItem!)
        } 
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK : - Hepler 
    private func dateLabelTextFromDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        if date.isMidnight(){
            dateFormatter.dateFormat = "MM-dd-yyyy"
        } else {
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        }
        return dateFormatter.stringFromDate(date)
    }

}
