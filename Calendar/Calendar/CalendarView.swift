//
//  CalendarView.swift
//  Calendar
//
//  Created by Sebastian Grabiński on 07.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

struct Identifiers {
    static let calendarCell = "DayCell"
    static let calendarHeader = "Header"
    static let calendarCellXIB = "CalendarCell"
    static let calendarHeaderXIB = "CalendarHeaderView"
}

class CalendarView: UIView {
    
    public var calendarDelegate : CalendarViewDelegate?
    
    open var dayDisabledTintColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    open var weekdayTintColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    open var weekendTintColor: UIColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
    open var todayTintColor: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    open var dateSelectionColor: UIColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    open var monthTitleColor: UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    open var barTintColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    
    public var currentDate: Date!
    
    fileprivate var selectedDates = [Date]()
    fileprivate var calendarEvents = [CalendarEvent]()
    
    open var startDate: Date?
    open var hightlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = true
    
    fileprivate(set) var startYear: Int = 2016
    fileprivate(set) var endYear: Int = 2018
    fileprivate var multiSelectEnabled: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.registerXIBs()
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.registerXIBs()
        self.createViews()
    }
    
    private func createViews() {
        self.registerXIBs()
        self.addSubview(calendarView)
        scrollToToday()
    }
    
    public func buildCalendarView(dayDisabledTintColor: UIColor, weekdayTintColor: UIColor, weekendTintColor: UIColor, todayTintColor: UIColor ,dateSelectionColor: UIColor, monthTitleColor: UIColor ,barTintColor: UIColor) {
        
        self.dayDisabledTintColor = dayDisabledTintColor
        self.weekdayTintColor = weekdayTintColor
        self.weekendTintColor = weekendTintColor
        self.todayTintColor = todayTintColor
        self.dateSelectionColor = dateSelectionColor
        self.monthTitleColor = monthTitleColor
        self.barTintColor = barTintColor
    }
    
    lazy var calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: frame.width, height: 100)
        
        var cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    private func registerXIBs() {
        calendarView.register(UINib(nibName: Identifiers.calendarCellXIB, bundle: Bundle(for: CalendarCell.self )), forCellWithReuseIdentifier: Identifiers.calendarCell)
        calendarView.register(UINib(nibName: Identifiers.calendarHeaderXIB, bundle: Bundle(for: CalendarHeaderView.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.calendarHeader)
    }
    
    private func scrollToToday () {
        let today = Date()
        DispatchQueue.main.async {
            self.scrollToMonthForDate(today)
        }
    }
    
    private func scrollToMonthForDate (_ date: Date) {
        let month = date.month()
        let year = date.year()
        let section = ((year - startYear) * 12) + month
        let indexPath = IndexPath(row:1, section: section - 1)
        
        self.calendarView.scrollToIndexpathByShowingHeader(indexPath)
    }
}

extension CalendarView: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if startYear > endYear {
            debugPrint("Start year can't be higher than end year!")
            return 0
        }
        let numberOfMonths = 12 * (endYear - startYear) + 12 
        return numberOfMonths
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(section)
        let addingPrefixDaysWithMonthDays = (firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - Calendar.current.firstWeekday)
        let addingSuffixDays = addingPrefixDaysWithMonthDays % 7
        var totalNumber = addingPrefixDaysWithMonthDays
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        return totalNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.calendarCell, for: indexPath) as! CalendarCell
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section )
        let prefixDays = ( firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday)
        let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row - prefixDays)
        let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth() - 1)
        
        if indexPath.row >= prefixDays {
            setCellSelectable(cell: cell, currentDate: currentDate)
            
            if filterDaysAndMonth(cell, currentDate, firstDayOfThisMonth){
                cell.selectCell(dateSelectionColor)
            } else {
                cell.deselectCell(weekdayTintColor)
                checkIfDateIsWeekend(cell: cell, currentDate: currentDate)
                makeSuffixCellsUnselectable(cell: cell, currentDate: currentDate, nextMonthFirstDay: nextMonthFirstDay)
                setTodayTintColor(cell: cell, currentDate: currentDate)
                disablePreviousDateCells(cell: cell)
            }
        }
            
        else {
            setPreviousMonthCells(cell, firstDayOfThisMonth, prefixDays, indexPath)
        }
        
        DispatchQueue.main.async {
            self.setUpEvents(cell: cell, indexPath: indexPath)
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    fileprivate func setCellSelectable(cell: CalendarCell, currentDate: Date) {
        cell.isSelectable = true
        cell.currentDate = currentDate
        cell.dayLabel.text = "\(currentDate.day())"
    }
    
    fileprivate func setPreviousMonthCells(_ cell: CalendarCell, _ firstDayOfThisMonth: Date, _ prefixDays : Int, _ indexPath: IndexPath) {
        
        cell.deselectCell(weekdayTintColor)
        cell.isSelectable = false
        let previousDay = firstDayOfThisMonth.dateByAddingDays( -( prefixDays - indexPath.row))
        cell.currentDate = previousDay + 1
        cell.dayLabel.text = "\(previousDay.day())"
        if hideDaysFromOtherMonth {
            cell.dayLabel.textColor = UIColor.clear
        } else {
            cell.dayLabel.textColor = dayDisabledTintColor
        }
    }
    
    private func makeSuffixCellsUnselectable(cell: CalendarCell, currentDate: Date, nextMonthFirstDay: Date) {
        if (currentDate > nextMonthFirstDay) {
            cell.isSelectable = false
            if hideDaysFromOtherMonth {
                cell.dayLabel.textColor = UIColor.clear
            } else {
                cell.dayLabel.textColor = dayDisabledTintColor
            }
        }
    }
    
    private func setTodayTintColor(cell: CalendarCell, currentDate: Date) {
        if currentDate.isToday() && hightlightsToday {
            cell.setTodayCellColor(todayTintColor)
        }
    }
    
    private func checkIfDateIsWeekend(cell: CalendarCell, currentDate: Date) {
        if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
            cell.dayLabel.textColor = weekendTintColor
        }
    }
    
    private func disablePreviousDateCells(cell: CalendarCell) {
        if startDate != nil {
            if Calendar.current.startOfDay(for: cell.currentDate as Date) < Calendar.current.startOfDay(for: startDate!) {
                cell.isSelectable = false
                cell.dayLabel.textColor = dayDisabledTintColor
            }
        }
    }
    
    private func filterDaysAndMonth(_ cell: CalendarCell, _ currentDate: Date, _ firstDayOfThisMonth: Date) -> Bool {
        return selectedDates.filter({ $0.isDateSameDay(currentDate) }).count > 0 && (firstDayOfThisMonth.month() == currentDate.month())
    }
    
}

    //MARK: - DataSource

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7
        return CGSize(width: screenWidth / 7, height: screenWidth / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.calendarHeader, for: indexPath) as? CalendarHeaderView else {
                print("No headerMate")
                return CalendarHeaderView()
            }
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            return setUpHeader(header, firstDayOfMonth)
        }
        return UICollectionReusableView()
    }
    
    private func setUpHeader(_ header: CalendarHeaderView, _ firstDayOfMonth: Date) -> CalendarHeaderView {
        header.monthLabel.text = firstDayOfMonth.monthNameFull()
        header.updateWeekdaysLabelColor(weekdayTintColor)
        header.updateWeekendLabelColor(weekendTintColor)
        header.backgroundColor = barTintColor
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        
        if cell.isSelectable! && multiSelectEnabled {
            if selectedDates.filter({ $0.isDateSameDay(cell.currentDate)
            }).count == 0 {
                selectedDates.append(cell.currentDate)
                cell.selectCell(dateSelectionColor)
                selectTodayCell(cell: cell)
                print(cell.currentDate)
                calendarDelegate?.calendar!(self, didSelectMultipleDate: selectedDates)
            }
            else {
                deselectCell(cell: cell)
                setTodayCellColor(cell: cell)
            }
        }
    }

    private func deselectCell(cell: CalendarCell) {
        selectedDates = selectedDates.filter() {
            cell.deselectCell(UIColor.clear)
            return  !($0.isDateSameDay(cell.currentDate))
        }
        if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
            cell.deselectCell(weekendTintColor)
        }
        else {
            cell.deselectCell(weekdayTintColor)
        }
    }
    
    private func setTodayCellColor(cell: CalendarCell) {
        if cell.currentDate.isToday() && hightlightsToday{
            cell.setTodayCellColor(todayTintColor)
        }
    }
    
    private func selectTodayCell(cell: CalendarCell) {
        if cell.currentDate.isToday() {
            cell.setTodayCellColor(dateSelectionColor)
        }
    }

}

// MARK: - Events

extension CalendarView {
    
    public func loadEventsToCalendar(events: [CalendarEvent]) {
        self.calendarEvents = events
    }
    
    fileprivate func setUpEvents(cell: CalendarCell, indexPath: IndexPath) {
        if calendarEvents.filter({ $0.startDate.isDateSameDay(cell.currentDate)}).count > 0 {
            cell.eventView.isHidden = false
        } else {
            cell.eventView.isHidden = true
        }
    }
    
}

















