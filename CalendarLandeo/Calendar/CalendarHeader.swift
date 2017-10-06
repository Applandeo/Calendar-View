//
//  CalendarHeader.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class CalendarHeader: UICollectionReusableView {
        
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let calendar = Calendar.current
        let weeksDayList = calendar.shortWeekdaySymbols
        
        if calendar.firstWeekday == 2 {
            mondayLabel.text = weeksDayList[1]
            tuesdayLabel.text = weeksDayList[2]
            wednesdayLabel.text = weeksDayList[3]
            thursdayLabel.text = weeksDayList[4]
            fridayLabel.text = weeksDayList[5]
            saturdayLabel.text = weeksDayList[6]
            sundayLabel.text = weeksDayList[7]
        } else {
            mondayLabel.text = weeksDayList[0]
            tuesdayLabel.text = weeksDayList[1]
            wednesdayLabel.text = weeksDayList[2]
            thursdayLabel.text = weeksDayList[3]
            fridayLabel.text = weeksDayList[4]
            saturdayLabel.text = weeksDayList[5]
            sundayLabel.text = weeksDayList[6]
        }
    }
    
    func updateWeekendLabelColor(_ color: UIColor) {
            saturdayLabel.textColor = color
            sundayLabel.textColor = color
    }
    
    func updateWeekdaysLabelColor(_ color: UIColor) {
        mondayLabel.textColor = color
        tuesdayLabel.textColor = color
        wednesdayLabel.textColor = color
        thursdayLabel.textColor = color
        fridayLabel.textColor = color
    }
}
