//
//  DateModel.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation
import UIKit

struct DateModel {
    
    static let startYear = 2016
    static let endYear = 2018
    static let multipleSelection = false
    
    static let dayDisabledTintColor = UIColor.gray
    static let weekdayTintColor = Colors.LightGreenColor
    static let weekendTintColor = Colors.BlueColor
    static let dateSelectionColor = Colors.OrangeColor
    static let monthTitleColor = Colors.BlueColor
    static let todayTintColor = Colors.YellowColor
    
    static let tintColor = Colors.OrangeColor
    static let barTintColor = UIColor.white
    
    static let headerSize = CGSize(width: 100, height: 80)
    
}

struct Colors {
    static let BlueColor = UIColor(red: (0/255), green: (21/255), blue: (63/255), alpha: 1.0)
    static let YellowColor = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
    static let LightGrayColor = UIColor(red: (230/255), green: (230/255), blue: (230/255), alpha: 1.0)
    static let OrangeColor = UIColor(red: (233/255), green: (159/255), blue: (94/255), alpha: 1.0)
    static let LightGreenColor = UIColor(red: (158/255), green: (206/255), blue: (77/255), alpha: 1.0)
}
