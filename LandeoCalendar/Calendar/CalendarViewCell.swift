//
//  CalendarViewCell.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    var selectionColor: UIColor?
    var todayTintColor: UIColor?
    var weekdayTintColor: UIColor?
    var todayCellTextColor: UIColor?
    var selectedCellTextColor: UIColor?
    
    let textLabel = UILabel()
    let dotsView = UIView()
    let bgView = UIView()
    
    let eventCounterLabel = UILabel()
    
    override var description: String {
        let dayString = self.textLabel.text ?? " "
        return "<DayCell (text:\"\(dayString)\")>"
    }
    
    var eventsCount = 0 {
        didSet {
            self.dotsView.isHidden = (eventsCount == 0)
            self.setNeedsLayout()
        }
    }
    
    var isToday : Bool = false {
        didSet {
            switch isToday {
            case true:
                self.setCellColor(backroundColor: CalendarStyle.cellTodayBackgroundColor, textColor: CalendarStyle.cellTodayTextColor)
            case false:
                self.setCellColor(backroundColor: CalendarStyle.cellBackgroundColor, textColor: CalendarStyle.cellTextColor)
            }
        }
    }
    
    override var isSelected : Bool {
        didSet {
            switch isSelected {
            case true:
                self.bgView.layer.borderColor = CalendarStyle.cellBorderColor.cgColor
                self.bgView.layer.borderWidth = CalendarStyle.cellBorderWidth
            case false:
                self.bgView.layer.borderColor = UIColor.clear.cgColor
                self.bgView.layer.borderWidth = 0.0
            }
        }
    }
    
    func setCellColor(backroundColor: UIColor, textColor: UIColor) {
        self.bgView.backgroundColor = backroundColor
        self.textLabel.textColor = textColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel.textAlignment = NSTextAlignment.center
        self.dotsView.backgroundColor = CalendarStyle.cellEventColor
        
        self.addSubview(self.bgView)
        self.addSubview(self.textLabel)
        self.addSubview(self.dotsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        
        if CalendarStyle.cellShape.isRound {
            let smallestSide = min(elementsFrame.width, elementsFrame.height)
            elementsFrame = elementsFrame.insetBy(
                dx: (elementsFrame.width - smallestSide) / 2.0,
                dy: (elementsFrame.height - smallestSide) / 2.0
            )
        }
        
        self.bgView.frame = elementsFrame
        self.textLabel.frame = elementsFrame
        
        let size = self.bounds.height * 0.08
        self.dotsView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.dotsView.center = CGPoint(x: self.textLabel.center.x, y: self.bounds.height - (2.5 * size))
        self.dotsView.layer.cornerRadius = size * 0.5
        
        switch CalendarStyle.cellShape {
        case .square:
            self.bgView.layer.cornerRadius = 0.0
        case .round:
            self.bgView.layer.cornerRadius = elementsFrame.width * 0.5
        }
    }
    
}
