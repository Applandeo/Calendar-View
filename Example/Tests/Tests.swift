import UIKit
import XCTest
@testable import ALCalendar

class Tests: XCTestCase {
    
    var calendar = CalendarView()
    
    override func setUp() {
        super.setUp()
        calendar.setCurrentDate(date: Date())
        
    }
    
}

public class CalendarViewTestingController: UIViewController {
    
    var calendarView: CalendarView!
    
    override public func viewDidLoad() {
         super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.allowMultipleSelection = true
        calendarView.frame = view.frame
        calendarView.layoutSubviews()
        

        self.view.addSubview(calendarView)
        print("ok")
    }
}

extension CalendarViewTestingController: CalendarViewDelegate {
    
    public func calendar(_ calendar : CalendarView, didSelectDate date : Date, withEvents: [CalendarEvent])  {

    }
    
    public func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        
    }

}
