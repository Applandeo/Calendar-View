//
//  ViewController.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalendarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = LandeoCalendar(startYear: 2016, endYear: 2018, multiSelection: true, selectedDates: [])
        calendar.calendarDelegate = self
        calendar.startDate = Date()
        calendar.highlightsToday = true
        calendar.showsTodayButton = true
        calendar.hideDaysFromOtherMonth = true
        calendar.tintColor = UIColor.green
        calendar.dayDisabledTintColor = UIColor.gray
        calendar.title = "Calendar"
        
//        let navigationController = UINavigationController(rootViewController: LandeoCalendar)
//        self.present(navigationController, animated: true, completion: nil)
    }

    func calendar(_: LandeoCalendar, didCancel error: NSError) {
        print("  ")
    }
    
    func calendar(_: LandeoCalendar, didSelectDate date: Date) {
        
    }
    
    func calendar(_: LandeoCalendar, didSelectMultipleDate dates: [Date]) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

