//
//  SinglePickerVC.swift
//  LandeoCalendar
//
//  Created by sebastian on 18.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import ALCalendar

class SinglePickerVC: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(calendarView)
        
        calendarView.delegate = self
        calendarView.showEkEvents = true
        calendarView.direction = .vertical
        
        CalendarStyle.cellEventColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        CalendarStyle.cellSelectionType = .single
        CalendarStyle.cellShape = .round
        CalendarStyle.cellBackgroundColor = UIColor.clear
        CalendarStyle.cellTodayBackgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        CalendarStyle.cellBorderColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        CalendarStyle.cellTextColor = UIColor.black
        CalendarStyle.cellTodayTextColor = UIColor.white

        CalendarStyle.headerTextColor = UIColor.blue
        CalendarStyle.textAlligment = .center
        CalendarStyle.headerFontSize = 20
        CalendarStyle.headerWeekdayFontSize = 14
        
        let today = Date()
        calendarView.setCurrentDate(date: today, animated: false)
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
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        print("dupa")
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
