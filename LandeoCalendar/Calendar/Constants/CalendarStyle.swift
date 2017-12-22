//
//  Style.swift
//  LandeoCalendar
//
//  Created by sebastian on 12.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

struct CalendarStyle {
    
    enum CellShapeOptions {
        case round
        case square
        
        var isRound: Bool {
            switch self {
            case .round:
                return true
            default:
                return false
            }
        }
    }
    
    enum CellSelectionType {
        case single
        case multiple
        case range
    }
    
    //Defaults
    static var cellBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3926056338)
    static var cellTextColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static var cellTodayTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var cellTodayBackgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    static var cellBorderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    static var cellBorderWidth: CGFloat = 2.0
    static var cellEventColor = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.8)
    static var cellShape = CellShapeOptions.round
    static var headerFontName: String = "Helvetica"
    static var headerTextColor = UIColor.gray
    static var headerHeight: CGFloat = 80.0
    static var cellSelectionType = CellSelectionType.single
}
