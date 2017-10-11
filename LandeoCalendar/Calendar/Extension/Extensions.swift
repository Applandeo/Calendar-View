//
//  Extensions.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 25.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
    var isOneDay: Bool {
        let components = Calendar.current.dateComponents([.era, .year, .month, .day], from: self.startDate, to: self.endDate)
        return (components.era == 0 && components.year == 0 && components.month == 0 && components.day == 0)
    }
}

extension Date {
    
    func applyOffSetOfMonth(calendar: Calendar, offset:Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = offset;
        return(calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options())
    }
}
