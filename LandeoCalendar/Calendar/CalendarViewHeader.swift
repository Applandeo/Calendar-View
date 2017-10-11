//
//  CalendarViewHeader.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class CalendarViewHeader: UIView {
    
    var monthLabelColor: UIColor?
    var weekdaysLabelColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var monthLabel : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "AvenirNext-DemiBold", size: 21.0)
        lbl.textColor = monthLabelColor
        self.addSubview(lbl)
        return lbl
    }()
    
    lazy var dayLabelContainerView : UIView = {
        
        let view = UIView()
        let formatter : DateFormatter = DateFormatter()
        for index in 1...7 {
            
            let day : NSString = formatter.weekdaySymbols[index % 7] as NSString
            let weekdayLabel = UILabel()
            weekdayLabel.font = UIFont(name: "Helvetica", size: 14.0)
            weekdayLabel.text = day.substring(to: 3).uppercased()
            weekdayLabel.textColor = weekdaysLabelColor
            weekdayLabel.textAlignment = NSTextAlignment.center
            view.addSubview(weekdayLabel)
        }
        
        self.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frm = self.bounds
        frm.origin.y += 5.0
        frm.size.height = 40.0
        
        self.monthLabel.frame = frm
        var labelFrame = CGRect(x: 0.0, y: self.bounds.size.height / 2.0, width: self.bounds.size.width / 7.0, height: self.bounds.size.height / 2.0)
        
        for lbl in self.dayLabelContainerView.subviews {
            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
    }
    
    func setHeaderColor(monthLabelColor: UIColor, weekdaysLabelColor: UIColor) {
        self.monthLabelColor = monthLabelColor
        self.weekdaysLabelColor = weekdaysLabelColor
    }
}
