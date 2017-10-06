//
//  CalendarHeader.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//
import UIKit

class CalendarHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var lblFourth: UILabel!
    @IBOutlet weak var lblFifth: UILabel!
    @IBOutlet weak var lblSixth: UILabel!
    @IBOutlet weak var lblSeventh: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let calendar = Calendar.current
        let weeksDayList = calendar.shortWeekdaySymbols
        
        lblFirst.text = weeksDayList[1]
        lblSecond.text = weeksDayList[2]
        lblThird.text = weeksDayList[3]
        lblFourth.text = weeksDayList[4]
        lblFifth.text = weeksDayList[5]
        lblSixth.text = weeksDayList[6]
        lblSeventh.text = weeksDayList[0]
        
    }
    
    func updateWeekendLabelColor(_ color: UIColor)
    {
        if Calendar.current.firstWeekday == 1 {
            lblSixth.textColor = color
            lblSeventh.textColor = color
        }
    }
    
    func updateWeekdaysLabelColor(_ color: UIColor) {
        if Calendar.current.firstWeekday == 1 {
            lblFirst.textColor = color
            lblSecond.textColor = color
            lblThird.textColor = color
            lblFourth.textColor = color
            lblFifth.textColor = color
        }
    }
}

