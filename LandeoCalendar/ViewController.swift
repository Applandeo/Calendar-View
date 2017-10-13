//
//  ViewController.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 20.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, CalendarViewDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.buildCalendarView(cellLabelTintColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                       selectCellTintColor: #colorLiteral(red: 0.1664928794, green: 0.7488424182, blue: 0.8295294642, alpha: 1),
                                       todayTintColor: #colorLiteral(red: 0.4514698386, green: 0.912237823, blue: 0.7296689153, alpha: 1),
                                       todayCellTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                       headerMonthLabelColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                                       headerWeekdaysLabelColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                                       weekdayTintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                       selectedCellTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        calendarView.direction = .horizontal
        calendarView.allowMultipleSelection = false
        calendarView.loadEKEvents = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var tommorowComponents = DateComponents()
        tommorowComponents.day = 1
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
        calendarView.loadEventsInCalendar()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.width - 16.0 * 2
        let height = width + 80
        self.calendarView.frame = CGRect(x: 16, y: 16, width: width, height: height)
    }
    
    func eventsEndDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let today = Date()
        let endDate = Calendar.current.date(byAdding: dateComponents, to: today)
        return endDate
    }
    
    func eventsStartDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = -1
        let today = Date()
        let startDate = Calendar.current.date(byAdding: dateComponents, to: today)
        return startDate
    }
    
    func loadEventsInCalendar() {
        if let  startDate = eventsStartDate(),
            let endDate = eventsEndDate() {
            
            let store = EKEventStore()
            let fetchEvents = { () -> Void in
                let predicate = store.predicateForEvents(withStart: startDate, end:endDate, calendars: nil)
                if let eventsBetweenDates = store.events(matching: predicate) as [EKEvent]? {
                    self.calendarView.events = eventsBetweenDates
                }
            }
            if EKEventStore.authorizationStatus(for: EKEntityType.event) != EKAuthorizationStatus.authorized {
                store.requestAccess(to: EKEntityType.event, completion: {(granted, error ) -> Void in
                    if granted {
                        fetchEvents()
                    }
                })
            } else {
                fetchEvents()
            }
        }
    }
    
    func calendar(_ calendar : CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        
    }
    
}

