//
//  ViewController.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalendarViewDelegate {

    @IBOutlet weak var calendarVIew: CalendarView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildCalendar()
        loadEvents()
    }
    
    func buildCalendar() {
        calendarVIew.buildCalendarView(dayDisabledTintColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
                                       weekdayTintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                       weekendTintColor: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),
                                       todayTintColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
                                       dateSelectionColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
                                       monthTitleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                                       barTintColor: UIColor.white)
        
        calendarVIew.startDate = Date()
    }
    
    func loadEvents() {
        let tommorow = Date().tomorrow
        let yesterday = Date().yesterday
        
        let events: [CalendarEvent] = [CalendarEvent(title: "woah", startDate: Date()),
                                       CalendarEvent(title: "mkay!", startDate: tommorow),
                                       CalendarEvent(title: "yes", startDate: yesterday)]
        calendarVIew.loadEventsToCalendar(events: events)
    }
}
