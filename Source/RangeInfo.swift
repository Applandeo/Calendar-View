//
//  Range.swift
//  LandeoCalendar
//
//  Created by sebastian on 27.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

class RangeInfo {

    var startMonthInfo: (firstDay: Int, daysTotal: Int)!
    var startIndexPath: IndexPath!
    var startmonthOffsetComponents: DateComponents!
    var correctStartMonthDate: Date!
    var endIndexPath: IndexPath!
    var startlastDayIndex: Int!
    
    init() { }
}
