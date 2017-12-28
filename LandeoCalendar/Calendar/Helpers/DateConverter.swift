//
//  DateConverter.swift
//  LandeoCalendar
//
//  Created by sebastian on 22.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

extension CalendarView {
    
    func indexPathForDate(_ date : Date) -> IndexPath? {
        let distanceFromStartDate = self.calendar.dateComponents([.month, .day], from: calendarModel.monthFirstDay, to: date)
        guard let day = distanceFromStartDate.day,
            let month = distanceFromStartDate.month,
            let (firstDayIndex, _) = calendarModel.monthInfoForSection[month] else { return nil }
        
        return IndexPath(
            item: day + firstDayIndex,
            section: month
        )
    }
    
    func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {
        let month = indexPath.section
        guard let monthInfo = calendarModel.monthInfoForSection[month] else { return nil }
        var components      = DateComponents()
        components.month    = month
        components.day      = indexPath.item - monthInfo.firstDay
        
        return self.calendar.date(byAdding: components, to: calendarModel.monthFirstDay)
    }
    
}
