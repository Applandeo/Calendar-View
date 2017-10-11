//
//  CalendarViewDataSource.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 25.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation

@objc protocol CalendarViewDataSource {
    
    func startDate() -> Date?
    func endDate() -> Date?
    
}
