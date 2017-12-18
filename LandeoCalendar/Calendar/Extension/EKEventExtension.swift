//
//  EKEventExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.10.2017.
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
