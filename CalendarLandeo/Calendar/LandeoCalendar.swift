//
//  Calendar.swift
//  CalendarLandeo
//
//  Created by sebastian on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import UIKit

private let CELL_ID = "Cell"
private let HEADER_ID = "Header"

@objc public protocol CalendarDelegate {
    @objc optional func calendar(_: LandeoCalendar, didCancel error: NSError)
    @objc optional func calendar(_: LandeoCalendar, didSelectDate date: Date)
    @objc optional func calendar(_: LandeoCalendar, didSelectMultipleDate dates: [Date])
}

open class LandeoCalendar: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    open var calendarDelegate: CalendarDelegate?
    open var multiSelectEnabled: Bool
    open var showsTodayButton: Bool = true
    fileprivate var selectedDates = [Date]()
    
    open var tintColor: UIColor
    open var dayDisabledTintColor: UIColor
    open var weekdayTintColor: UIColor
    open var weekendTintColor: UIColor
    open var dateSelectionColor: UIColor
    open var monthTitleColor: UIColor
    open var todayTintColor: UIColor
    open var barTintColor: UIColor

    open var startDate: Date?
    open var endDate: Date?
    open var highlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = false
    
    open var backgroundImage: UIImage?
    open var backgroundColor: UIColor?
    
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = self.tintColor
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
//        self.navigationController?.navigationBar.titleTextAttributes =  [NSFontAttributeName: ]
        
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        
        self.collectionView?.register(UINib(nibName: "LandeoCell", bundle: Bundle(for: LandeoCalendar.self)), forCellWithReuseIdentifier: CELL_ID)
            self.collectionView?.register(UINib(nibName: "LandeoHeader", bundle: Bundle(for: LandeoCalendar.self)), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        
        scrollToToday()
        
        initBarButton()
        
//        bgImage

    }
    
    func initBarButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(LandeoCalendar.cancelButtonDidPress))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        var arrayBarButtons = [UIBarButtonItem]()
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(LandeoCalendar.doneButtonDidPress))
            arrayBarButtons.append(doneButton)
        }
        
        if showsTodayButton {
            let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(LandeoCalendar.scrollToToday))
            arrayBarButtons.append(todayButton)
            todayButton.tintColor = todayTintColor
        }
        
        self.navigationItem.rightBarButtonItems = arrayBarButtons
    }
    
    public convenience init() {
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: DateModel.multipleSelection, selectedDates: nil)
    }

    public convenience init(multiSelection: Bool) {
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public convenience init(startYear: Int, endYear: Int) {
        self.init(startYear: startYear, endYear: endYear, multiSelection: DateModel.multipleSelection, selectedDates: nil)
    }
    
    public convenience init(startYear: Int, endYear: Int, multiSelection: Bool) {
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public init(startYear: Int, endYear: Int, multiSelection: Bool, selectedDates: [Date]?) {
        
        self.startYear = startYear
        self.endYear = endYear
        
        self.multiSelectEnabled = multiSelection
        
        self.todayTintColor = DateModel.todayTintColor
        self.tintColor = DateModel.tintColor
        self.barTintColor = DateModel.barTintColor
        self.dayDisabledTintColor = DateModel.dayDisabledTintColor
        self.weekdayTintColor = DateModel.weekdayTintColor
        self.weekendTintColor = DateModel.weekendTintColor
        self.dateSelectionColor = DateModel.dateSelectionColor
        self.monthTitleColor = DateModel.monthTitleColor
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = DateModel.headerSize
        
        if let _ = selectedDates {
            self.selectedDates.append(contentsOf: selectedDates!)
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if startYear > endYear {
            return 0
        }
        
        let numberOfMonths = 12 * (endYear - startYear) + 12
        return numberOfMonths
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfTheMonth = startDate?.dateByAddingMonths(section)
        
        let monthBeforeCurrent = ((firstDayOfTheMonth?.numberOfDaysInMonth())! + (firstDayOfTheMonth?.weekday())! - Calendar.current.firstWeekday)
        let monthAfter = monthBeforeCurrent % 7
        var totalNumber = monthBeforeCurrent
        
        if monthAfter != 0 {
            totalNumber = totalNumber + (7 - monthAfter)
        }
        
        return 0
    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! CalendarCell
        
        let calendarStartDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = calendarStartDate?.dateByAddingMonths(indexPath.section)
        let prefixDays = ((firstDayOfMonth?.weekday())! - Calendar.current.firstWeekday)
        
        if indexPath.row >= prefixDays {
            cell.isSelectable = true
            let currentDate = firstDayOfMonth?.dateByAddingMonths(indexPath.row - prefixDays)
            let nextMonthFirstDay = firstDayOfMonth?.dateByAddingDays((firstDayOfMonth?.numberOfDaysInMonth())! - 1 )
            
            cell.currentDate = currentDate
            cell.dayLabel.text = "\(currentDate!.day())"
            
            if selectedDates.filter({ $0.isSameDate(currentDate!)}).count > 0 && (firstDayOfMonth?.month() == currentDate?.month()) {
                cell.selectedForLabelColor(dateSelectionColor)
            } else {
                cell.deSelectForLabelColor(weekdayTintColor)
                
                if currentDate! > nextMonthFirstDay! {
                    cell.isSelectable = false
                    if hideDaysFromOtherMonth {
                        cell.dayLabel.textColor = UIColor.clear
                    } else {
                        cell.dayLabel.textColor = self.dayDisabledTintColor
                    }
                }
                
                if (currentDate?.isToday())! {
                    cell.setTodayCellColor(todayTintColor)
                }
                
                if startDate != nil {
                    if Calendar.current.startOfDay(for: cell.currentDate!) < Calendar.current.startOfDay(for: startDate!) {
                        cell.isSelectable = false
                        cell.dayLabel.textColor = self.dayDisabledTintColor
                    }
                }
            }
            
        } else  {
            cell.deSelectForLabelColor(weekdayTintColor)
            cell.isSelectable = false
            let previousDay = firstDayOfMonth?.dateByAddingDays(-(prefixDays - indexPath.row))
            cell.currentDate = previousDay
            cell.dayLabel.text = "\(previousDay)"
            if hideDaysFromOtherMonth {
                cell.dayLabel.textColor = UIColor.clear
            } else {
                cell.dayLabel.textColor = self.dayDisabledTintColor
            }
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 5, 0); //top,left,bottom,right
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width / 7
        return CGSize(width: screenWidth / 7, height: screenWidth / 7)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_ID, for: indexPath) as? CalendarHeader else { return CalendarCell() }
            
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate?.dateByAddingMonths(indexPath.section)
            
            header.monthLabel.text = firstDayOfMonth?.monthFullName()
            header.monthLabel.textColor = monthTitleColor
            header.updateWeekendLabelColor(weekendTintColor)
            header.updateWeekdaysLabelColor(weekdayTintColor)
            header.backgroundColor = UIColor.clear
            
            return header
        }
        return CalendarHeader()
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
        
        if !multiSelectEnabled && cell.isSelectable! {
            calendarDelegate?.calendar!(self, didSelectDate: cell.currentDate!)
            cell.selectedForLabelColor(dateSelectionColor)
            dismiss(animated: true, completion: nil)
            return
        }
        
        if cell.isSelectable! {
            if selectedDates.filter({$0.isSameDate(cell.currentDate!)}).count == 0 {
                selectedDates.append(cell.currentDate!)
                
                cell.selectedForLabelColor(dateSelectionColor)
                
                if (cell.currentDate?.isToday())! {
                    cell.setTodayCellColor(dateSelectionColor)
                }
                
            } else {
                selectedDates = selectedDates.filter() {
                    return !($0.isSameDate(cell.currentDate!))
                }
                
                if (cell.currentDate?.isSunday())! || (cell.currentDate?.isSaturday())! {
                    cell.deSelectForLabelColor(weekendTintColor)
                } else {
                    cell.deSelectForLabelColor(weekdayTintColor)
                }
                
                if (cell.currentDate?.isToday())! && highlightsToday {
                    cell.setTodayCellColor(todayTintColor)
                }
            }
        }
    }
    
    @objc internal func scrollToToday() {
        let today = Date()
        scrollToMonthForDate(today)
    }
    
    @objc internal func cancelButtonDidPress() {
        calendarDelegate?.calendar!(self, didCancel: NSError(domain: "LandeoCalendarErrorDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "User Cancled Selection"]))
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func doneButtonDidPress() {
        calendarDelegate?.calendar!(self, didSelectMultipleDate: selectedDates)
        dismiss(animated: true, completion: nil)
    }
    
    open func scrollToMonthForDate(_ date: Date) {
        let month = date.month()
        let year = date.year()
        let section = ((year! - startYear) * 12) + month!
        let indexPath = IndexPath(row: 1, section: section - 1)
        
        self.collectionView?.scrollToItem(at: indexPath, at: .right , animated: true)
    }
    
}
