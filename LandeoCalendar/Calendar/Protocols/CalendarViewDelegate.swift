//
//  CalendarViewDelegate.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 25.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

@objc protocol CalendarViewDelegate {
    
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) -> Void
    func calendar(_ calendar : CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) -> Void
    @objc optional func calendar(_ calendar : CalendarView, didDeselectDate date : Date) -> Void
}
