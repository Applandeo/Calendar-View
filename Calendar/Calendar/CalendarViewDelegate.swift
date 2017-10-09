//
//  CalendarViewDelegate.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation

@objc protocol CalendarViewDelegate{

    @objc optional    func calendar(_: CalendarView, didSelectMultipleDate dates : [Date])
}
