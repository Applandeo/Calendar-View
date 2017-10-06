//
//  Calendar.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 04.10.2017.
//  Copyright © 2017 AppLandeo. All rights reserved.
//

import Foundation
import UIKit

struct Identifiers {
    static let calendarCellID = "CalendarCell"
    static let calendarHeaderID = "CalendarHeader"
}

open class LandeoCalendar: UICollectionViewController {
    
    open var calendarDelegate : CalendarDelegate?
    open var multiSelectEnabled: Bool
    open var showsTodaysButton: Bool = true
    fileprivate var selectedDates = [Date]()
    
    //UI
    open var tintColor: UIColor
    open var dayDisabledTintColor: UIColor
    open var weekdayTintColor: UIColor
    open var weekendTintColor: UIColor
    open var todayTintColor: UIColor
    open var dateSelectionColor: UIColor
    open var monthTitleColor: UIColor
    open var barTintColor: UIColor
    
    open var startDate: Date?
    open var hightlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = false
    
    //Background
    open var backgroundImage: UIImage?
    open var backgroundColor: UIColor?
    
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        registerXibs()
        inititlizeBarButtons()
        setupNavigationController()
        setBagroundImage()
        
        DispatchQueue.main.async { () -> Void in
            self.scrollToToday()
        }
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = self.tintColor
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:self.tintColor]
    }
    
    func setupCollectionView() {
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
    }
    
    func registerXibs() {
        self.collectionView!.register(UINib(nibName: "CalendarCell", bundle: Bundle(for: LandeoCalendar.self )), forCellWithReuseIdentifier: Identifiers.calendarCellID)
        self.collectionView!.register(UINib(nibName: "CalendarHeaderView", bundle: Bundle(for: LandeoCalendar.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.calendarHeaderID)
    }
    
    func inititlizeBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(LandeoCalendar.onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        var arrayBarButtons  = [UIBarButtonItem]()
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(LandeoCalendar.onTouchDoneButton))
            arrayBarButtons.append(doneButton)
        }
        if showsTodaysButton {
            let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action:#selector(LandeoCalendar.onTouchTodayButton))
            arrayBarButtons.append(todayButton)
            todayButton.tintColor = todayTintColor
        }
        
        self.navigationItem.rightBarButtonItems = arrayBarButtons
    }
    
    func setBagroundImage() {
        if backgroundImage != nil {
            self.collectionView!.backgroundView =  UIImageView(image: backgroundImage)
        } else if backgroundColor != nil {
            self.collectionView?.backgroundColor = backgroundColor
        } else {
            self.collectionView?.backgroundColor = UIColor.white
        }
    }
    
    // MARK : - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(){
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: DateModel.multiSelection, selectedDates: nil);
    }
    
    public convenience init(startYear: Int, endYear: Int) {
        self.init(startYear:startYear, endYear:endYear, multiSelection: DateModel.multiSelection, selectedDates: nil)
    }
    
    public convenience init(multiSelection: Bool) {
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public convenience init(startYear: Int, endYear: Int, multiSelection: Bool) {
        self.init(startYear: DateModel.startYear, endYear: DateModel.endYear, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public init(startYear: Int, endYear: Int, multiSelection: Bool, selectedDates: [Date]?) {
        
        self.startYear = startYear
        self.endYear = endYear
        
        self.multiSelectEnabled = multiSelection
        
        self.tintColor = DateModel.tintColor
        self.barTintColor = DateModel.barTintColor
        self.dayDisabledTintColor = DateModel.dayDisabledTintColor
        self.weekdayTintColor = DateModel.weekdayTintColor
        self.weekendTintColor = DateModel.weekendTintColor
        self.dateSelectionColor = DateModel.dateSelectionColor
        self.monthTitleColor = DateModel.monthTitleColor
        self.todayTintColor = DateModel.todayTintColor
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = DateModel.headerSize
        layout.scrollDirection = .vertical
        
        if let _ = selectedDates  {
            self.selectedDates.append(contentsOf: selectedDates!)
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    //MARK: Button Actions
    
    @objc internal func onTouchCancelButton() {
        calendarDelegate?.calendar!(self, didCancel: NSError(domain: "CalendarViewErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func onTouchDoneButton() {
        calendarDelegate?.calendar!(self, selectedDates: selectedDates)
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func onTouchTodayButton() {
        scrollToToday()
    }
    
    open func scrollToToday () {
        let today = Date()
        scrollToMonthForDate(today)
    }
    
    open func scrollToMonthForDate (_ date: Date) {
        
        let month = date.month()
        let year = date.year()
        let section = ((year - startYear) * 12) + month
        let indexPath = IndexPath(row:1, section: section-1)
        
        self.collectionView?.scrollToIndexpathByShowingHeader(indexPath)
    }
    
    // MARK: - Events
    
    func showEventsOnCalendar(with date: Date, indexPath: IndexPath) {
        
    }
    
}
// MARK: - UICollectionViewDataSource
extension LandeoCalendar {
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if startYear > endYear {
            debugPrint("Start year can't be higher than end year!")
            return 0
        }
        let numberOfMonths = 12 * (endYear - startYear) + 12 // + 1 years to both sides, just to make calendar look better.
        return numberOfMonths
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = Date(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(section) //set firstDayOfMonth
        let addingPrefixDaysWithMonthDays = ( firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - Calendar.current.firstWeekday ) //Days of month + Days from next and previous month
        let addingSuffixDays = addingPrefixDaysWithMonthDays % 7 //check if all days are correct
        var totalNumber = addingPrefixDaysWithMonthDays
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        
        return totalNumber
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.calendarCellID, for: indexPath) as! CalendarCell
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section )
        let prefixDays = ( firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday - 1)
        let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row - prefixDays)
        let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth() - 1)
        
        if indexPath.row >= prefixDays {
            setCellSelectable(cell: cell, currentDate: currentDate)
            
            if validateDate(cell, currentDate, firstDayOfThisMonth) {
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
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    private func setPreviousMonthCells(_ cell: CalendarCell, _ firstDayOfThisMonth: Date, _ prefixDays : Int, _ indexPath: IndexPath) {
        cell.deselectCell(weekdayTintColor)
        cell.isCellSelectable = false
        let previousDay = firstDayOfThisMonth.dateByAddingDays( -( prefixDays - indexPath.row))
        cell.currentDate = previousDay
        cell.dayLabel.text = "\(previousDay.day())"
        if hideDaysFromOtherMonth {
            cell.dayLabel.textColor = UIColor.clear
        } else {
            cell.dayLabel.textColor = self.dayDisabledTintColor
        }
    }
    
    private func setCellSelectable(cell: CalendarCell, currentDate: Date) {
        cell.isCellSelectable = true
        cell.currentDate = currentDate
        cell.dayLabel.text = "\(currentDate.day())"
    }
    
    private func makeSuffixCellsUnselectable(cell: CalendarCell, currentDate: Date, nextMonthFirstDay: Date) {
        if (currentDate > nextMonthFirstDay) {
            cell.isCellSelectable = false
            if hideDaysFromOtherMonth {
                cell.dayLabel.textColor = UIColor.clear
            } else {
                cell.dayLabel.textColor = self.dayDisabledTintColor
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
                cell.isCellSelectable = false
                cell.dayLabel.textColor = self.dayDisabledTintColor
            }
        }
    }
    
    private func validateDate(_ cell: CalendarCell, _ currentDate: Date, _ firstDayOfThisMonth: Date) -> Bool {
        return selectedDates.filter({ $0.isDateSameDay(currentDate) }).count > 0 && (firstDayOfThisMonth.month() == currentDate.month())
    }
}

// MARK: - CollectionViewDelegate
extension LandeoCalendar {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7
        return CGSize(width: screenWidth / 7, height: screenWidth / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifiers.calendarHeaderID, for: indexPath) as! CalendarHeaderView
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            return setUpHeader(header, firstDayOfMonth)
        }
        return UICollectionReusableView()
    }
    
    private func setUpHeader(_ header: CalendarHeaderView, _ firstDayOfMonth: Date) -> CalendarHeaderView {
        header.lblTitle.text = firstDayOfMonth.monthNameFull()
        header.lblTitle.textColor = monthTitleColor
        header.updateWeekdaysLabelColor(weekdayTintColor)
        header.updateWeekendLabelColor(weekendTintColor)
        header.backgroundColor = UIColor.clear
        return header
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        if !multiSelectEnabled && cell.isCellSelectable! {
            calendarDelegate?.calendar!(self, selectedDate: cell.currentDate)
            cell.selectCell(dateSelectionColor)
            return
        }
        
        if cell.isCellSelectable! {
            if selectedDates.filter({ $0.isDateSameDay(cell.currentDate)
            }).count == 0 {
                selectedDates.append(cell.currentDate)
                cell.selectCell(dateSelectionColor)
                selectTodayCell(cell: cell)
            }
            else {
                deselectCell(cell: cell)
                setTodayCellColor(cell: cell)
            }
        }
    }
    
    private func deselectCell(cell: CalendarCell) {
        selectedDates = selectedDates.filter(){
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

