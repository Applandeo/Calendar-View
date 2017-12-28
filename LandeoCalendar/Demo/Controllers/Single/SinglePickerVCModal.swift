//
//  SingleVC.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 20.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import EventKit

class SinglePickerVCModal: UIViewController, CalendarViewDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var backgroundDismissView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCalendar()
    }
    
    func setUpCalendar() {
        calendarView.direction = .horizontal
        
        calendarView.backgroundColor = UIColor.white
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.backgroundDismissView.addGestureRecognizer(tap)
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        CalendarStyle.cellSelectionType = .single
        CalendarStyle.cellShape = .round
        CalendarStyle.cellBackgroundColor = UIColor.clear
        CalendarStyle.cellTodayBackgroundColor = #colorLiteral(red: 0.9782553315, green: 0.3780350089, blue: 0.4415892363, alpha: 1)
        CalendarStyle.cellBorderColor = #colorLiteral(red: 0.1664928794, green: 0.7488424182, blue: 0.8295294642, alpha: 1)
        CalendarStyle.cellEventColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarStyle.headerTextColor = UIColor.black
        CalendarStyle.cellTextColor = UIColor.black
        CalendarStyle.cellTodayTextColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        calendarView.setDisplayDate(date: today, animated: false)
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delegate
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print("Month : - \(date)")
    }
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calendarView.setDisplayDate(date: picker.date, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
