//
//  RangePickerVC.swift
//  LandeoCalendar
//
//  Created by sebastian on 18.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class RangePickerVC: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCalendar()
    }
    
    func setUpCalendar() {
        calendarView.direction = .horizontal
        
        calendarView.backgroundColor = UIColor.white
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 8
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        CalendarStyle.cellSelectionType = .range
        CalendarStyle.cellShape = .round
        CalendarStyle.cellBackgroundColor = UIColor.clear
        CalendarStyle.cellTodayBackgroundColor = #colorLiteral(red: 0.9782553315, green: 0.3780350089, blue: 0.4415892363, alpha: 1)
        CalendarStyle.cellBorderColor = #colorLiteral(red: 0.1664928794, green: 0.7488424182, blue: 0.8295294642, alpha: 1)
        CalendarStyle.cellEventColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarStyle.headerTextColor = UIColor.black
        CalendarStyle.cellTextColor = UIColor.black
        CalendarStyle.cellTodayTextColor = UIColor.white
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
