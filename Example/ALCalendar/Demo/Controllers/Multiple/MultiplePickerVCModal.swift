//
//  MultiplePickerVCModal.swift
//  LandeoCalendar
//
//  Created by sebastian on 18.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import ALCalendar

class MultiplePickerVCModal: UIViewController, CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var backgroundDismissView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        calendarView.delegate = self
        calendarView.showEkEvents = true
        calendarView.direction = .vertical
        
        let today = Date()
        calendarView.setCurrentDate(date: today, animated: false)
        
        CalendarStyle.cellEventColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        CalendarStyle.cellSelectionType = .multiple
        CalendarStyle.cellShape = .square
        CalendarStyle.cellBackgroundColor = UIColor.clear
        CalendarStyle.cellTodayBackgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        CalendarStyle.cellBorderColor = #colorLiteral(red: 0.1664928794, green: 0.7488424182, blue: 0.8295294642, alpha: 1)
        CalendarStyle.headerTextColor = UIColor.black
        CalendarStyle.cellTextColor = UIColor.black
        CalendarStyle.cellTodayTextColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.backgroundDismissView.addGestureRecognizer(tap)
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
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        print("huj")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

