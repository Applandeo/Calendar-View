//
//  CalendarHeaderView.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    
    override func awakeFromNib() {
        let calendar = Calendar.current
        let weeksDayList = calendar.shortWeekdaySymbols

        firstLabel.text = weeksDayList[1]
        secondLabel.text = weeksDayList[2]
        thirdLabel.text = weeksDayList[3]
        fourthLabel.text = weeksDayList[4]
        fifthLabel.text = weeksDayList[5]
        sixthLabel.text = weeksDayList[6]
        seventhLabel.text = weeksDayList[0]
        
    }
    
    func updateWeekendLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 1 {
            sixthLabel.textColor = color
            seventhLabel.textColor = color
        }
    }
    
    func updateWeekdaysLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 1 {
            firstLabel.textColor = color
            secondLabel.textColor = color
            thirdLabel.textColor = color
            fourthLabel.textColor = color
            fifthLabel.textColor = color
        }
    }
    
}
