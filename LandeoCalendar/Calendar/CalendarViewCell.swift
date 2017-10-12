//
//  CalendarViewCell.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    var selectionColor: UIColor?
    var todayTintColor: UIColor?
    var weekdayTintColor: UIColor?
    var todayCellTextColor: UIColor?
    var selectedCellTextColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.cellBackgroundView)
        self.textLabel.frame = self.bounds
        self.addSubview(self.textLabel)
        self.addSubview(self.dotsView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpDotView()
    }
    
    func setUpDotView() {
        let dotFactor : CGFloat = 0.07
        let size = self.bounds.height*dotFactor
        self.dotsView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.dotsView.center = CGPoint(x: self.textLabel.center.x, y: self.bounds.height - 3*size)
        self.dotsView.layer.cornerRadius = size * 0.5
    }
    
    var eventsCount = 0 {
        didSet {
            self.dotsView.isHidden = eventsCount == 0
            self.setNeedsLayout()
        }
    }
    
    override var isSelected : Bool {
        didSet {
            if isSelected {
                guard let selection = selectionColor else {
                    return selectionColor = UIColor.white
                }                
                setCellColor(selection, selectedCellTextColor!)
            } else {
                if isToday {
                    setCellColor(todayTintColor!, todayCellTextColor!)
                } else {
                    setCellColor(UIColor.clear, UIColor.black)
                }
            }
        }
    }
    
    var isToday : Bool = false {
        didSet {
            if isToday {
                setCellColor(todayTintColor!, UIColor.white)
            } else {
                setCellColor(UIColor.clear, UIColor.black)
            }
        }
    }
    
    func setCellColor(_ backgroundColor: UIColor, _ labelColor: UIColor) {
        self.cellBackgroundView.backgroundColor = backgroundColor
        self.textLabel.textColor = labelColor
    }
    
    
    lazy var cellBackgroundView : UIView = {
        var vFrame = self.frame.insetBy(dx: 3.0, dy: 6.7)
        let view = UIView(frame: vFrame)
        view.layer.cornerRadius = vFrame.width / 2
        view.layer.borderWidth = 0.0
        view.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "AvenitNext", size: 21)
        label.textColor = weekdayTintColor
        return label
        
    }()
    
    lazy var dotsView : UIView = {
        let dotView = UIView()
        dotView.backgroundColor = UIColor.red
        return dotView
        
    }()
    
    func cellColors(selectionColor: UIColor, todayTintColor: UIColor, weekdayTintColor: UIColor, todayCellTextColor: UIColor, selectedCellTextColor: UIColor) {
        self.selectionColor = selectionColor
        self.todayTintColor = todayTintColor
        self.weekdayTintColor = weekdayTintColor
        self.todayCellTextColor = todayCellTextColor
        self.selectedCellTextColor = selectedCellTextColor
    }
}
