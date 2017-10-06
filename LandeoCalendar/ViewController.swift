//
//  ViewController.swift
//  LandeoCalendar
//
//  Created by sebastian on 05.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalendarDelegate {
    
    @IBOutlet weak var datesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showCalendarButtonDidPress(_ sender: Any) {
        let calendar = LandeoCalendar(startYear: 2016, endYear: 2018, multiSelection: true, selectedDates: [])
        calendar.calendarDelegate = self
        calendar.startDate = Date()
        calendar.hightlightsToday = true
        calendar.showsTodaysButton = true
        calendar.hideDaysFromOtherMonth = true
        calendar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        calendar.barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        calendar.dayDisabledTintColor = UIColor.gray
        calendar.title = "Date Picker"
        
        let navigationController = UINavigationController(rootViewController: calendar)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func calendar(_: LandeoCalendar, didCancel error: NSError) {
        datesTextView.text = "User Canceled Selection"
    }

    func calendar(_: LandeoCalendar, selectedDate date: Date) {
        datesTextView.text = "User selected date \(date)"
    }

    func calendar(_: LandeoCalendar, selectedDates dates : [Date]) {
        datesTextView.text = "User selected dates \(dates)"
    }
}
