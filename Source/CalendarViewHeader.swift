//
//  CalendarViewHeader.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

open class CalendarHeaderView: UIView {
    
    var month: String?
    var year: Int?
    
    lazy var monthLabel : PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = CalendarStyle.textAlligment
        label.font = UIFont(name: CalendarStyle.headerFontName, size: CalendarStyle.headerFontSize)
        label.textColor = CalendarStyle.headerTextColor
        
        self.addSubview(label)
        return label
    }()
    
    lazy var weekdaysContainerView : UIView = {
        let containerView = UIView()
        let formatter = DateFormatter()
        
        for index in 1...7 {
            let weekdayLabel = UILabel()
            weekdayLabel.font = UIFont(name: CalendarStyle.headerFontName, size: CalendarStyle.headerWeekdayFontSize)
            weekdayLabel.text = formatter.shortWeekdaySymbols[(index % 7)]
            weekdayLabel.textColor = CalendarStyle.headerTextColor
            weekdayLabel.textAlignment = NSTextAlignment.center
            containerView.addSubview(weekdayLabel)
        }
        self.addSubview(containerView)
        return containerView
    }()
    
    open override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = self.bounds
        rect.origin.y += 5.0
        rect.size.height = 40.0        
        self.monthLabel.frame = rect
        
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0,
            height: self.bounds.size.height / 2.0
        )
        
        for label in self.weekdaysContainerView.subviews {
            label.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
        
    }
    
}

