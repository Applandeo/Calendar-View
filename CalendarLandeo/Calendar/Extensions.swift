//
//  Extensions.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation

extension Date {
    
    init?(year: Int, month: Int, day: Int) {
        
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        guard let valueToReturn = calendar.date(from: dateComponent) else { return nil }
        self = valueToReturn
    }
    
    func dateByAddingDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func dateByAddingMonths (_ months: Int) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        guard let days = calendar.range(of: .day, in: .month, for: self) else { return 0 }
        return days.count
    }
    
    func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: self)
        guard let dateToReturn = calendar.date(from: dateComponent) else { return Date() }
        return dateToReturn
    }
    
    func monthFullName() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM YYYY"
        return dateFormater.string(from: self)
    }
    
    func isToday() -> Bool {
        return self.isSameDate(Date())
    }
    
    func weekday() -> Int? {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.weekday], from: self)
        guard let weekday = dateComponent.weekday else { return 0 }
        return weekday
    }
    
    func year() -> Int? {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year], from: self)
        guard let year = dateComponent.year else { return 0 }
        return year
    }
    
    func month() -> Int? {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.month], from: self)
        guard let month = dateComponent.month else { return 0 }
        return month
    }
    
    func day() -> Int? {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.day], from: self)
        guard let day = dateComponent.day else { return 0 }
        return day
    }
    
    func isSameDate(_ date: Date) -> Bool {
        return (self.day() == date.day() && self.month() == date.month() && self.year() == date.year())
        
    }
    
    func isSunday() -> Bool {
        return self.weekday() == 1
    }
    
    func isSaturday() -> Bool {
        return self.weekday() == 7
    }
}
