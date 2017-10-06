//
//  CalendarDelegate.swift
//  LandeoCalendar
//
//  Created by sebastian on 05.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation

@objc public protocol CalendarDelegate{
    
    @objc optional func calendar (_: LandeoCalendar, didCancel error : NSError)
    @objc optional func calendar (_: LandeoCalendar, selectedDate date : Date)
    @objc optional func calendar (_: LandeoCalendar, selectedDates dates : [Date])
}
