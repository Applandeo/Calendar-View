//
//  CalendarCell.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var currentDate: Date?
    var isSelectable: Bool?
    
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selectedForLabelColor(_ color: UIColor) {
        dayLabel.layer.cornerRadius = self.dayLabel.frame.size.width / 2
        dayLabel.layer.backgroundColor = color.cgColor
        dayLabel.textColor = UIColor.white
    }
    
    func deSelectForLabelColor(_ color: UIColor) {
        dayLabel.layer.backgroundColor = UIColor.clear.cgColor
        dayLabel.textColor = color
    }
    
    func setTodayCellColor(_ color: UIColor) {
        dayLabel.layer.cornerRadius = dayLabel.frame.size.width / 2
        dayLabel.layer.backgroundColor = color.cgColor
        dayLabel.textColor = UIColor.white
        
    }
}
