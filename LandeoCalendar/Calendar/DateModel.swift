//
//  DateModel.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation
import UIKit

struct DateModel  {
    //Values
    static let startYear = 2016
    static let endYear = 2018
    static let multiSelection = false
    
    //Colors
    static let dayDisabledTintColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
    static let weekdayTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let weekendTintColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
    static let dateSelectionColor = #colorLiteral(red: 1, green: 0.4585607345, blue: 0.5054351973, alpha: 1)
    static let monthTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let todayTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    
    static let tintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    static let barTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    //HeaderSize
    static let headerSize = CGSize(width: UIScreen.main.bounds.width ,height: 80)
}

