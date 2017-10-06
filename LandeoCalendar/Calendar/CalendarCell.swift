//
//  CalendarCell.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var currentDate: Date!
    var isCellSelectable: Bool?
    
    @IBOutlet weak var dayLabel: UILabel!
    
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
}

