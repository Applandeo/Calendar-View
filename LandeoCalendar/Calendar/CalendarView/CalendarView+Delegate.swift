//
//  CalendarView+Delegate.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = self.dateFromIndexPath(indexPath) else { return }
        
        if let index = calendarModel.selectedIndexPaths.index(of: indexPath) {
            deselectCell(date: date, index: index)
        } else {
            selectCell(date: date, indexPath: indexPath)
        }
        self.reloadData()
    }
    
    fileprivate func deselectCell(date: Date, index: Int) {
        calendarModel.selectedIndexPaths.remove(at: index)
        calendarModel.selectedDates.remove(at: index)
        delegate?.calendar(self, didDeselectDate: date)
    }
    
    fileprivate func selectCell(date: Date, indexPath: IndexPath) {
        
        switch CalendarStyle.cellSelectionType {
        case .range:
            rangeSelection(indexPath, date)
        case .multiple:
            calendarModel.selectedDates.append(date)
            calendarModel.selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = calendarModel.eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
            
        case .single:
            calendarModel.selectedDates.removeAll()
            calendarModel.selectedIndexPaths.removeAll()
            calendarModel.selectedDates.append(date)
            calendarModel.selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = calendarModel.eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dateBeingSelected = self.dateFromIndexPath(indexPath) else { return false }
        if let delegate = self.delegate {
            return delegate.calendar(self, canSelectDate: dateBeingSelected)
        }
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateAndNotifyScrolling()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateAndNotifyScrolling()
    }
    
    func updateAndNotifyScrolling() {
        guard let date = self.dateFromScrollViewPosition() else { return }
        self.displayDateOnHeader(date)
        self.delegate?.calendar(self, didScrollToMonth: date)
    }
    
    @discardableResult
    func dateFromScrollViewPosition() -> Date? {
        var page: Int = 0
        
        switch self.direction {
            case .horizontal: page = Int(floor(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width))
            case .vertical: page = Int(floor(self.collectionView.contentOffset.y / self.collectionView.bounds.size.height))
        }
        
        page = page > 0 ? page : 0
        var monthsOffsetComponents = DateComponents()
        monthsOffsetComponents.month = page
        
        return self.calendar.date(byAdding: monthsOffsetComponents, to: calendarModel.monthFirstDay)
    }
    
    func displayDateOnHeader(_ date: Date) {
        let month = self.calendar.component(.month, from: date) // get month
        let monthName = DateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        let year = self.calendar.component(.year, from: date)
        
        self.headerView.monthLabel.text = monthName + " " + String(year)
        self.currentDate = date
    }
}

//MARK: - Range Selection

extension CalendarView {
    fileprivate func rangeSelection(_ indexPath: IndexPath, _ date: Date) {
        let startIndexPath: IndexPath?
        
        if calendarModel.selectedIndexPaths.count > 1  {
            startIndexPath = indexPath
            calendarModel.selectedIndexPaths.append(startIndexPath!)
            calendarModel.selectedDates.append(date)
            calendarModel.selectedIndexPaths.removeAll()
        }
        
        if calendarModel.selectedIndexPaths.count == 1 {
            selectRange(startIndexPath: calendarModel.selectedIndexPaths[0], endIndexPath: indexPath, date: date)
        }
        
        if calendarModel.selectedIndexPaths.isEmpty {
            calendarModel.selectedIndexPaths.append(indexPath)
        }
    }
    
    func selectRange(startIndexPath: IndexPath, endIndexPath: IndexPath, date: Date) {
        calendarModel.selectedIndexPaths.append(endIndexPath)
        calendarModel.selectedDates.append(date)
        
        let range = RangeInfo()
        
        range.startIndexPath = startIndexPath
        range.endIndexPath = endIndexPath
        
        range.startmonthOffsetComponents = DateComponents()
        range.startmonthOffsetComponents.month = range.startIndexPath.section
        range.correctStartMonthDate = self.calendar.date(byAdding: range.startmonthOffsetComponents, to: calendarModel.monthFirstDay)
        range.startMonthInfo = self.getMonthInfo(for: range.correctStartMonthDate)
        range.startlastDayIndex = range.startMonthInfo.daysTotal + range.startMonthInfo.firstDay
        
        if range.endIndexPath < range.startIndexPath {
            swap(&range.endIndexPath, &range.startIndexPath)
        }
        
        repeat {
            getCurrentMonthInfo(range: range)
        } while (range.startIndexPath.isLessThan(range.endIndexPath))
    }
    
    fileprivate func getCurrentMonthInfo(range: RangeInfo) {
        range.startIndexPath = range.startIndexPath.increaseRowByOne(sectionEnd: range.startlastDayIndex)
        calendarModel.selectedIndexPaths.append(range.startIndexPath)
        
        if range.startIndexPath.row == 0 || range.startIndexPath.row == range.startlastDayIndex {
            range.startmonthOffsetComponents.month = range.startIndexPath.section
            range.correctStartMonthDate = self.calendar.date(byAdding: range.startmonthOffsetComponents, to: calendarModel.monthFirstDay)!
            range.startMonthInfo = self.getMonthInfo(for: range.correctStartMonthDate)!
            range.startlastDayIndex = range.startMonthInfo.firstDay + range.startMonthInfo.daysTotal
        }
    }
    
}
