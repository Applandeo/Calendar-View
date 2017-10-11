//
//  DateExtension.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.10.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func applyOffSetOfMonth(calendar: Calendar, offset:Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = offset;
        return(calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options())
    }
}
