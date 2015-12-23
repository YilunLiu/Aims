//
//  CalendarPickerViewController.swift
//  Aims
//
//  Created by Yilun Liu on 12/18/15.
//  Copyright © 2015 Yilun Liu. All rights reserved.
//

import UIKit
import ReactiveCocoa
import CocoaLumberjackSwift

class CalendarPickerViewController: UIViewController, CVCalendarMenuViewDelegate, CVCalendarViewDelegate, CVCalendarViewAppearanceDelegate{

    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var enableTimeSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var parentObserver: Observer<NSDateComponents, NoError>!
    var date: NSDate?
    
    private var dateObserver: Observer<CVDate, NoError>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let (calendarSignal, dateObserver) = Signal<CVDate, NoError>.pipe()
        let (timeSignal, timeObserver) = Signal<NSDate, NoError>.pipe()
        self.dateObserver = dateObserver

        datePicker.rac_newDateChannelWithNilValue(NSDate()).subscribeNext{
            next in
            if let time = next as? NSDate{
                timeObserver.sendNext(time)
            }
        }
        
        combineLatest(calendarSignal, timeSignal)
            .observeNext { (calendarDate, timeDate) -> () in
                let dateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: timeDate)
                dateComponents.year = calendarDate.year
                dateComponents.month = calendarDate.month
                dateComponents.day = calendarDate.day
                self.parentObserver.sendNext(dateComponents)
                DDLogInfo("A time is selected: \(dateComponents)")
        }
        
        enableTimeSwitch.rac_newOnChannel().subscribeNext{
            next in
            let on = next as! Bool
            if (!on) {
                timeObserver.sendNext(NSDate.midNight())
            } else {
                timeObserver.sendNext(self.datePicker.date)
            }
            
            self.datePicker.hidden = !on
        }
        
        // Initialize View (Calendar Timer) States
        enableTimeSwitch.setOn(false, animated: false)
        datePicker.hidden = true
        timeObserver.sendNext(NSDate.midNight())
        dateObserver.sendNext(CVDate(date: NSDate()))
        
        if let date = self.date {
            self.calendarView.toggleViewWithDate(date)
            self.dateObserver.sendNext(CVDate(date: date))
            if !date.isMidnight(){
                datePicker.hidden = false
                enableTimeSwitch.setOn(true, animated: false)
                datePicker.date = date
                timeObserver.sendNext(date)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Target & Acitons
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        parentObserver?.sendInterrupted()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        parentObserver?.sendCompleted()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - CVCalendarViewDelegate
    func firstWeekday() -> Weekday {
        return Weekday.Sunday
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        DDLogInfo("Calendar: \(dayView.date.commonDescription) is selected" )
        dateObserver.sendNext(dayView.date)
        
    }
    
    // MARK: - CVCalendarViewAppearanceDelegate
    
    
}