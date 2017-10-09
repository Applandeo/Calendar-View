//
//  CalendarCell.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var isSelectable: Bool?
    var currentDate: Date!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selectCell(_ color: UIColor) {
        self.dayLabel.layer.cornerRadius = self.dayLabel.frame.size.width / 2
        self.dayLabel.layer.backgroundColor = color.cgColor
        self.dayLabel.textColor = UIColor.white
    }
    
    func deselectCell(_ color: UIColor) {
        self.dayLabel.layer.backgroundColor = UIColor.clear.cgColor
        self.dayLabel.textColor = color
    }
    
    func setTodayCellColor(_ backgroundColor: UIColor) {
        self.dayLabel.layer.cornerRadius = self.dayLabel.frame.size.width / 2
        self.dayLabel.layer.backgroundColor = backgroundColor.cgColor
        self.dayLabel.textColor  = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let dotFactor : CGFloat = 0.10
        let size = self.bounds.height*dotFactor
        self.eventView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.eventView.center = CGPoint(x: self.dayLabel.center.x, y: self.dayLabel.center.y + size * 3)
        self.eventView.layer.cornerRadius = size * 0.5
    }
}
    
    

