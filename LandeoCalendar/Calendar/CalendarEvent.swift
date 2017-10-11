//
//  CalendarEvent.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 25.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

@objc class CalendarEvent : NSObject {
    private(set) var title: String
    private(set) var startDate: Date
    private(set) var endDate:Date
    public init(title: String, startDate: Date, endDate: Date) {
        self.title = title;
        self.startDate = startDate;
        self.endDate = endDate;
    }
}

