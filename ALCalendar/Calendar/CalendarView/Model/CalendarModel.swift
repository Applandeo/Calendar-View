//
//  CalendarModel.swift
//  LandeoCalendar
//
//  Created by sebastian on 28.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

class CalendarModel {

    var startDate : Date!
    var endDate : Date!
    var monthFirstDay : Date!
    var today : Date!
    var todayIndexPath: IndexPath!
    var selectedIndexPaths : [IndexPath]!
    var selectedDates : [Date]!
    var eventsByIndexPath : [IndexPath:[CalendarEvent]]!
    var monthInfoForSection : [Int:(firstDay:Int, daysTotal:Int)]!
    
    //TODO: Defaults in init
    init() {
//        self.selectedIndexPaths = selectedIndexPaths[IndexPath]()
    }
}
