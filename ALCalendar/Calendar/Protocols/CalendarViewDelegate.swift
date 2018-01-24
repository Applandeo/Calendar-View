//
//  CalendarViewDelegate.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 25.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

public protocol CalendarViewDelegate {
    
    func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) -> Void
    func calendar(_ calendar : CalendarView, didSelectDate date : Date, withEvents: [CalendarEvent]) -> Void
    func calendar(_ calendar : CalendarView, didDeselectDate date : Date) -> Void
}

extension CalendarViewDelegate {
    public func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool { return true }
    public func calendar(_ calendar : CalendarView, didDeselectDate date : Date) -> Void { return }
}
