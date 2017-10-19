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
    
    fileprivate var startCalendarDate : Date = Date()
    fileprivate var endCalendarDate : Date = Date()
    fileprivate var startOfMonthCache : Date = Date()
    fileprivate var todayIndexPath : IndexPath?

    var displayDate : Date?
    var monthInfo : [Int:[Int]] = [Int:[Int]]()
    
    fileprivate(set) var selectedIndexPaths : [IndexPath] = [IndexPath]()
    fileprivate(set) var selectedDatesByUser : [Date] = [Date]()
    fileprivate var dateBeingSelectedByUser : Date?
    fileprivate var selectedDates: [Date] = [Date]()

    fileprivate var eventsByIndexPath : [IndexPath:[CalendarEvent]] = [IndexPath:[CalendarEvent]]()
    
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
    
    var direction : UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = self.calendarView.collectionViewLayout as? CalendarFlowLayout {
                layout.scrollDirection = direction
                self.calendarView.reloadData()
            }
        }
    }
    
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
                print("Start Date: - \(eventsStartDate)")
                print("End Date: - \(eventsEndDate)")
                if let eventsBetweenDates = store.events(matching: predicate) as [EKEvent]? {
                    self.events = eventsBetweenDates
                }
            }
            if EKEventStore.authorizationStatus(for: EKEntityType.event) != EKAuthorizationStatus.authorized {
                store.requestAccess(to: EKEntityType.event, completion: {(granted, error ) -> Void in
                    if granted {
                        fetchEvents()
                    }
                })
            } else {
                fetchEvents()
            }
        }
    }
}

extension CalendarView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let currentMonthInfo : [Int] = monthInfo[indexPath.section] else { return false }
        let firstDayInMonth = currentMonthInfo[FIRST_DAY_INDEX]
        
        var offsetComponents = DateComponents()
        offsetComponents.month = indexPath.section
        offsetComponents.day = indexPath.item - firstDayInMonth
        
        if let dateUserSelected = self.gregorian.date(byAdding: offsetComponents, to: startOfMonthCache) {
            dateBeingSelectedByUser = dateUserSelected
            selectedDatesByUser.append(dateUserSelected)
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dateBeingSelectedByUser = dateBeingSelectedByUser else {
            return
        }
        
        guard let currentMonthInfo : [Int] = monthInfo[indexPath.section] else { return }
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - currentMonthInfo[FIRST_DAY_INDEX], section: indexPath.section)
        var eventsArray : [CalendarEvent] = [CalendarEvent]()
        
        if let eventsForDay = eventsByIndexPath[fromStartOfMonthIndexPath] {
            eventsArray = eventsForDay
        }

        delegate?.calendar(self, didSelectDate: dateBeingSelectedByUser)
        selectedIndexPaths.append(indexPath)
        selectedDates.append(dateBeingSelectedByUser)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let dateBeingSelectedByUser = dateBeingSelectedByUser else {
            return
        }
        
        guard let index = selectedIndexPaths.index(of: indexPath) else {
            return
        }
        
        delegate?.calendar(self, didDeselectDate: dateBeingSelectedByUser)
        selectedIndexPaths.remove(at: index)
        selectedDates.remove(at: index)
        
        if allowMultipleSelection {
            self.dateBeingSelectedByUser = selectedDates.last
        } else {
            self.dateBeingSelectedByUser = nil
        }
    }
    
    func setDisplayDate(_ date : Date, animated: Bool) {
        if let dispDate = self.displayDate {
            
            if  date.compare(dispDate) == ComparisonResult.orderedSame {
                return
            }
            
            if  date.compare(startCalendarDate) == ComparisonResult.orderedAscending ||
                date.compare(endCalendarDate) == ComparisonResult.orderedDescending   {
                return
            }
            
            let difference = gregorian.dateComponents([.month], from: startOfMonthCache, to: date)
            let distance : CGFloat = CGFloat(difference.month!) * self.calendarView.frame.size.width
            self.calendarView.setContentOffset(CGPoint(x: distance, y: 0.0), animated: animated)
            _ = self.calculateDateBasedOnScrollViewPosition()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let startDate = Date.returnYearFromToday(-2), let endDate = Date.returnYearFromToday(2) else {
            return 0
        }
        
        startCalendarDate = startDate
        endCalendarDate = endDate
        
        if gregorian.compare(startDate, to: endDate, toGranularity: .day) != ComparisonResult.orderedAscending {
            return 0
        }
        
        var firstDayOfStartMonth = gregorian.dateComponents( [.era, .year, .month], from: startCalendarDate)
        firstDayOfStartMonth.day = 1
        guard let dateFromDayOneComponents = self.gregorian.date(from: firstDayOfStartMonth) else {
            return 0
        }
        
        startOfMonthCache = dateFromDayOneComponents
        setTodayIndexPath()
        
        return  gregorian.getCalendarMonths(from: startCalendarDate, to: endCalendarDate)
    }
    
    func setTodayIndexPath() {
        let today = Date()
        if  startOfMonthCache.compare(today) == ComparisonResult.orderedAscending &&
            endCalendarDate.compare(today) == ComparisonResult.orderedDescending {
            let differenceComponent = gregorian.getCalendarDay(from: startOfMonthCache, to: today)
            self.todayIndexPath = IndexPath(item: differenceComponent.day!, section: differenceComponent.month!) //we are sure we have data here, so force unwrap
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = section
        
        guard let correctMonthForSectionDate = self.gregorian.date(byAdding: monthOffsetComponents, to: startOfMonthCache) else {
            return 0
        }
        
        setNumberOfDaysInMonth(correctMonthForSectionDate, section)
        return NUMBER_OF_DAYS_IN_WEEK * MAXIMUM_NUMBER_OF_ROWS //42
    }
    
    func setNumberOfDaysInMonth(_ correctMonthForSectionDate: Date, _ section: Int) {
        let numberOfDaysInMonth = (self.gregorian as NSCalendar).range(of: .day, in: .month, for: correctMonthForSectionDate).length
        var firstWeekdayOfMonthIndex = gregorian.component( .weekday, from: correctMonthForSectionDate)
        
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7
        
        monthInfo[section] = [firstWeekdayOfMonthIndex, numberOfDaysInMonth]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CalendarCellID, for: indexPath) as? CalendarViewCell else { return CalendarViewCell() }
        
        guard let currentMonthInfo : [Int] = monthInfo[indexPath.section] else { return UICollectionViewCell() }
        let firstDayIndex = currentMonthInfo[FIRST_DAY_INDEX]
        let numberOfDays = currentMonthInfo[NUMBER_OF_DAYS_INDEX]
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - firstDayIndex, section: indexPath.section)
        let day = String(fromStartOfMonthIndexPath.item + 1)
        
        if indexPath.item >= firstDayIndex && indexPath.item < firstDayIndex + numberOfDays {
            setUpCell(dayCell, day)
        } else {
            dayCell.isHidden = true
        }
        
        checkCollectionViewPosition(indexPath, collectionView)
        setTodayCell(dayCell, indexPath, firstDayIndex)
        checkForEventsInCell(dayCell, fromStartOfMonthIndexPath)
        
        return dayCell
    }
    
    func setUpCell(_ cell: CalendarViewCell, _ day: String) {
        cell.textLabel.text = day
        cell.isHidden = false
        cell.cellColors(selectionColor: colors.selectCellTintColor, todayTintColor: colors.todayTintColor, weekdayTintColor: colors.weekdayTintColor, todayCellTextColor: colors.todayCellTextColor, selectedCellTextColor: colors.selectedCellTextColor)
    }
    
    func checkCollectionViewPosition(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        if indexPath.section == 0 && indexPath.item == 0 {
            self.scrollViewDidEndDecelerating(collectionView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let yearDate = self.calculateDateBasedOnScrollViewPosition()
        
        if  let date = yearDate,
            let delegate = self.delegate {
            
            delegate.calendar(self, didScrollToMonth: date)
            self.displayDate = date
        }
    }
    
    func setTodayCell(_ cell: CalendarViewCell, _ indexPath: IndexPath, _ firstDayIndex: Int) {
        if let index = todayIndexPath {
            cell.isToday = (index as IndexPath).section == indexPath.section && (index as IndexPath).item + firstDayIndex == indexPath.item
        }
    }
    
    func checkForEventsInCell(_ cell: CalendarViewCell, _ fromStartOfMonthIndexPath: IndexPath ) {
        if let eventsForDay = eventsByIndexPath[fromStartOfMonthIndexPath] {
            cell.eventsCount = eventsForDay.count
        } else {
            cell.eventsCount = 0
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let yearDate = self.calculateDateBasedOnScrollViewPosition()
        if let date = yearDate,
            let delegate = self.delegate {
            delegate.calendar(self, didScrollToMonth: date)
        }
    }
    
    func calculateDateBasedOnScrollViewPosition() -> Date? {
        let rect = self.calendarView.bounds
        
        var page = pageOffSet(rect: rect)
        page = page > 0 ? page : 0
        
        var monthsOffsetComponents = DateComponents()
        monthsOffsetComponents.month = page
        
        guard let yearDate = gregorian.date(byAdding: monthsOffsetComponents, to: self.startOfMonthCache) else {
            return nil
        }
        
        setUpHeaderViewDate(yearDate)
        return yearDate;
    }
    
    func setUpHeaderViewDate(_ yearDate: Date) {
        let month = self.gregorian.component(.month, from: yearDate)
        let monthName = DateFormatter().monthSymbols[ (month - 1) % 12]
        let year = self.gregorian.component(.year, from: yearDate)
        self.headerView.monthLabel.text = monthName + " " + String(year)
        self.displayDate = yearDate
    }
    
    func pageOffSet(rect: CGRect) -> Int {
        if self.direction == .horizontal {
            return Int(floor(self.calendarView.contentOffset.x / rect.size.width))
        } else {
            return Int(floor(self.calendarView.contentOffset.y / rect.size.height))
        }
    }
}
