//
//  CalendarView.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import EventKit

struct Identifiers {
    static let CalendarCellID = "CalendarCellID"
    static let HeaderViewID = "HeaderViewID"
}

class CalendarView: UIView {
    
    open var colors: CalendarColors = CalendarColors()
    
    //Mark: - Data
    var delegate : CalendarViewDelegate?
    
    var startCalendarDate = Date()
    var endCalendarDate = Date()
    var startOfMonthCache = Date()
    var todayIndexPath: IndexPath?

    var displayDate: Date?
    var monthInfo = [Int:[Int]]()
    var monthInfoForSection = [Int:(firstDay:Int, daysTotal:Int)]()
    
    var selectedIndexPaths = [IndexPath]()
    var selectedDatesByUser = [Date]()
    
    var dateBeingSelectedByUser: Date?
    var selectedDates = [Date]()

    var eventsByIndexPath = [IndexPath:[CalendarEvent]]()
    
    var direction : UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = self.calendarView.collectionViewLayout as? CalendarFlowLayout {
                layout.scrollDirection = direction
                self.calendarView.reloadData()
            }
        }
    }
    
//MARK: - Lazy Variables
    
    lazy var headerView : CalendarViewHeader = {
        let headerView = CalendarViewHeader(frame:CGRect.zero)
        return headerView
    }()
    
    lazy var calendarView : UICollectionView = {
        
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction;
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        
        return cv
    }()
    
    lazy var calendar: Calendar = {
        return Calendar.current
    }()
    
    lazy var gregorian : Calendar = {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(abbreviation: UTC)!
        return calendar
    }()
    
     open var loadEKEvents: Bool? = false {
        didSet{
            if loadEKEvents! {
                loadEventsInCalendar()
            }
        }
    }

//MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame :frame)
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setFrames()
    }
    
    func setFrames() {
        let height = frame.size.height - HEADER_DEFAULT_HEIGHT
        let width = frame.size.width
        self.headerView.frame   = CGRect(x:0.0, y:0.0, width: width, height:HEADER_DEFAULT_HEIGHT)
        self.calendarView.frame = CGRect(x:0.0, y:HEADER_DEFAULT_HEIGHT, width: width, height: height)
        setLayout(width: width, height: height)
    }
    
    func setLayout(width: CGFloat, height: CGFloat){
        guard let layout = self.calendarView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: width / CGFloat(NUMBER_OF_DAYS_IN_WEEK), height: height / CGFloat(MAXIMUM_NUMBER_OF_ROWS))
        self.headerView.setHeaderColor(monthLabelColor: colors.headerMonthLabelColor , weekdaysLabelColor: colors.headerWeekdaysLabelColor)
    }
    
// MARK: - Setup
    
    open func buildCalendarView(cellLabelTintColor: UIColor, selectCellTintColor: UIColor, todayTintColor: UIColor, todayCellTextColor: UIColor, headerMonthLabelColor: UIColor, headerWeekdaysLabelColor: UIColor, weekdayTintColor: UIColor, selectedCellTextColor: UIColor) {
        colors.cellLabelTintColor = cellLabelTintColor
        colors.selectCellTintColor = selectCellTintColor
        colors.headerWeekdaysLabelColor = headerWeekdaysLabelColor
        colors.todayCellTextColor = todayCellTextColor
        colors.weekdayTintColor = weekdayTintColor
        colors.headerMonthLabelColor = headerMonthLabelColor
        colors.todayTintColor = todayTintColor
        colors.selectedCellTextColor = selectedCellTextColor
    }
    
    fileprivate func createSubviews() {
        self.clipsToBounds = true
        self.calendarView.register(CalendarViewCell.self, forCellWithReuseIdentifier: Identifiers.CalendarCellID)
        self.calendarView.allowsMultipleSelection = allowMultipleSelection
        self.addSubview(self.headerView)
        self.addSubview(self.calendarView)
    }
    
    var allowMultipleSelection : Bool = false {
        didSet{
            self.calendarView.allowsMultipleSelection = allowMultipleSelection
        }
    }
    
    //Events
    
    fileprivate func setUpEvents(_ event: EKEvent, _ secondsFromGMTDifference: TimeInterval) {
        let startDate = event.startDate.addingTimeInterval(secondsFromGMTDifference)
        let endDate = event.endDate.addingTimeInterval(secondsFromGMTDifference)
        
        let distanceFromStartComponent = self.gregorian.dateComponents([.month,.day], from: startDate)
        let calendarEvent = CalendarEvent(title: event.title, startDate: startDate, endDate: endDate)
        let indexPath = IndexPath(item: distanceFromStartComponent.day!, section: distanceFromStartComponent.month!)
        
        if (eventsByIndexPath[indexPath] != nil) {
            eventsByIndexPath[indexPath]?.append(calendarEvent)
        } else {
            eventsByIndexPath[indexPath] = [calendarEvent]
        }
    }
    
    var events : [EKEvent]? {
        didSet {
            eventsByIndexPath = [IndexPath:[CalendarEvent]]()
            
            guard let events = events else {
                return
            }
            let secondsFromGMTDifference = TimeInterval(NSTimeZone.local.secondsFromGMT())
            for event in events {
                
                if event.isOneDay == false {
                    return
                }
                
                setUpEvents(event, secondsFromGMTDifference)
            }
            self.calendarView.reloadData()
        }
    }
    
    func loadEventsInCalendar() {
        
        if let  eventsStartDate =  Date().dateMonthFromToday(-12),
            let eventsEndDate = Date().dateMonthFromToday(12) {

            let store = EKEventStore()
            let fetchEvents = { () -> Void in
                let predicate = store.predicateForEvents(withStart: eventsStartDate, end:eventsEndDate, calendars: nil)
                if let eventsBetweenDates = store.events(matching: predicate) as [EKEvent]? {
                    self.events = eventsBetweenDates
                }
            }
            if EKEventStore.authorizationStatus(for: EKEntityType.event) != EKAuthorizationStatus.authorized {
                store.requestAccess(to: EKEntityType.event, completion: {(granted, error ) -> Void in
                    if granted {
                        fetchEvents()
                        print("Events Loaded")
                    }
                })
            } else {
                fetchEvents()
            }
        }
    }
}

extension CalendarView {
    
    func selectDate(_ date: Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        
        self.calendarView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        self.collectionView(calendarView, didSelectItemAt: indexPath)
        
    }
    
    func deselectDate(_ date: Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        
        self.calendarView.deselectItem(at: indexPath, animated: false)
        self.collectionView(calendarView, didSelectItemAt: indexPath)
    }
    
}


extension CalendarView {
    
    func indexPathForDate(_ date : Date) -> IndexPath? {
        
        let distanceFromStartDate = self.calendar.dateComponents([.month, .day], from: self.startOfMonthCache, to: date)
        
        guard
            let day   = distanceFromStartDate.day,
            let month = distanceFromStartDate.month,
            let (firstDayIndex, _) = monthInfoForSection[month] else { return nil }
        
        return IndexPath(
            item: day + firstDayIndex,
            section: month
        )
        
    }
    
    func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {
        
        let month = indexPath.section
        
        guard let monthInfo = monthInfoForSection[month] else { return nil }
        
        var components      = DateComponents()
        components.month    = month
        components.day      = indexPath.item - monthInfo.firstDay
        
        return self.calendar.date(byAdding: components, to: self.startOfMonthCache)
        
    }
}
