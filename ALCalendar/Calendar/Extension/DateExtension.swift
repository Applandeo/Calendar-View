//
//  DateExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.10.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    public func isDateLesser(date: Date) -> Bool {
        if self < date {
            return true
        }
        return false
    }
    
    func applyOffSetOfMonth(calendar: Calendar, offset:Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = offset
        return calendar.date(byAdding: dateComponents, to: self)
    }
    
    static func returnYearFromToday(_ year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        let today = Date()
        let startDate = Calendar.current.date(byAdding: dateComponents, to: today)
        return startDate
    }
    
    func dateMonthFromToday(_ month: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = month
        let today = Date()
        let date = Calendar.current.date(byAdding: dateComponents, to: today)
        return date
    }
    
    func lastDayOfMonth() -> Date {
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount = dayRange?.count
        var components = calendar.dateComponents([.year,.month,.day], from: self)
        components.day = dayCount
        return calendar.date(from: components)!
    }
    
}


