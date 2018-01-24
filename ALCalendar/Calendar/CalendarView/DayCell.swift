//
//  DayCell.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

open class DayCell: UICollectionViewCell {
    
    var selectionColor: UIColor?
    var todayTintColor: UIColor?
    var weekdayTintColor: UIColor?
    var todayCellTextColor: UIColor?
    var selectedCellTextColor: UIColor?
    
    let textLabel = UILabel()
    let dotsView = UIView()
    let background = UIView()
    
    override open var description: String {
        let dayString = self.textLabel.text ?? ""
        return "<DayCell (text:\"\(dayString)\")>"
    }
    
    var eventsCount = 0 {
        didSet {
            self.dotsView.isHidden = (eventsCount == 0)
            self.setNeedsLayout()
            self.layoutIfNeeded()
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
    
    fileprivate func setBackgroundBorder(borderColor: UIColor, borderWidth: CGFloat) {
        self.background.layer.borderColor = borderColor.cgColor
        self.background.layer.borderWidth = borderWidth
    }
    
    override open var isSelected : Bool {
        didSet {
            if isSelected {
                setBackgroundBorder(borderColor: CalendarStyle.cellBorderColor, borderWidth: CalendarStyle.cellBorderWidth)
            } else {
                setBackgroundBorder(borderColor: UIColor.clear ,borderWidth: 0.0)
            }
        }
    }
    
    func setCellColor(backroundColor: UIColor, textColor: UIColor) {
        self.background.backgroundColor = backroundColor
        self.textLabel.textColor = textColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel.textAlignment = NSTextAlignment.center
        
        self.addSubview(self.background)
        self.addSubview(self.textLabel)
        self.addSubview(self.dotsView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        var elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        
        if CalendarStyle.cellShape.isRound {
            setRoundedShape(&elementsFrame)
        }
        
        self.background.frame = elementsFrame
        self.textLabel.frame = elementsFrame
        
        setUpDotsView()
        
        self.background.layer.cornerRadius = CalendarStyle.cellShape == .square
            ? 0.0 : elementsFrame.width * 0.5
    }
    
    fileprivate func setRoundedShape(_ elementsFrame: inout CGRect) {
        let smallestSide = min(elementsFrame.width, elementsFrame.height)
        elementsFrame = elementsFrame.insetBy(
            dx: (elementsFrame.width - smallestSide) / 2.0,
            dy: (elementsFrame.height - smallestSide) / 2.0
        )
    }
    
    fileprivate func setUpDotsView() {
        let size = self.bounds.height * 0.08
        self.dotsView.backgroundColor = CalendarStyle.cellEventColor
        self.dotsView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.dotsView.center = CGPoint(x: self.textLabel.center.x, y: self.bounds.height - (2.5 * size))
        self.dotsView.layer.cornerRadius = size * 0.5
    }
}
