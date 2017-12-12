//
//  CalendarViewHeader.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
    
    lazy var monthLabel : UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: CalendarStyle.headerFontName, size: 20.0)
        lbl.textColor = CalendarStyle.headerTextColor
        
        self.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var dayLabelContainerView : UIView = {
        
        let v = UIView()
        
        let formatter = DateFormatter()
        
        for index in 1...7 {
            
            let weekdayLabel = UILabel()
            
            weekdayLabel.font = UIFont(name: CalendarStyle.headerFontName, size: 14.0)
            
            weekdayLabel.text = formatter.shortWeekdaySymbols[(index % 7)]
            weekdayLabel.textColor = CalendarStyle.headerTextColor
            weekdayLabel.textAlignment = NSTextAlignment.center
            
            v.addSubview(weekdayLabel)
        }
        
        self.addSubview(v)
        
        return v
        
    }()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var frm = self.bounds
        frm.origin.y += 5.0
        frm.size.height = 40.0
        
        self.monthLabel.frame = frm
        
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0,
            height: self.bounds.size.height / 2.0
        )
        
        for lbl in self.dayLabelContainerView.subviews {
            
            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
        
    }
    
}

