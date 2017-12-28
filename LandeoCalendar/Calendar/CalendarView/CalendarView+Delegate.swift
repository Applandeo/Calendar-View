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
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            deselectCell(date: date, index: index)
        } else {
            selectCell(date: date, indexPath: indexPath)
        }
        self.reloadData()
    }
    
    fileprivate func deselectCell(date: Date, index: Int) {
        selectedIndexPaths.remove(at: index)
        selectedDates.remove(at: index)
        delegate?.calendar(self, didDeselectDate: date)
    }
    
    fileprivate func selectCell(date: Date, indexPath: IndexPath) {
        
        switch CalendarStyle.cellSelectionType {
        case .range:
            rangeSelection(indexPath, date)
        case .multiple:
            selectedDates.append(date)
            selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
            
        case .single:
            selectedDates.removeAll()
            selectedIndexPaths.removeAll()
            selectedDates.append(date)
            selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
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
        
        return self.calendar.date(byAdding: monthsOffsetComponents, to: self.startOfMonthCache)
    }
    
    func displayDateOnHeader(_ date: Date) {
        let month = self.calendar.component(.month, from: date) // get month
        let monthName = DateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        let year = self.calendar.component(.year, from: date)
        
        self.headerView.monthLabel.text = monthName + " " + String(year)
        self.displayDate = date
    }
}

//MARK: - Range Selection

extension CalendarView {
    fileprivate func rangeSelection(_ indexPath: IndexPath, _ date: Date) {
        let startIndexPath: IndexPath?
        
        if selectedIndexPaths.count > 1  {
            startIndexPath = indexPath
            selectedIndexPaths.append(startIndexPath!)
            selectedDates.append(date)
            selectedIndexPaths.removeAll()
        }
        
        if selectedIndexPaths.count == 1 {
            selectRange(startIndexPath: selectedIndexPaths[0], endIndexPath: indexPath, date: date)
        }
        
        if selectedIndexPaths.isEmpty {
            selectedIndexPaths.append(indexPath)
        }
    }
    
    func selectRange(startIndexPath: IndexPath, endIndexPath: IndexPath, date: Date) {
        selectedIndexPaths.append(endIndexPath)
        selectedDates.append(date)
        
        let range = RangeInfo()
        
        range.startIndexPath = startIndexPath
        range.endIndexPath = endIndexPath
        
        range.startmonthOffsetComponents = DateComponents()
        range.startmonthOffsetComponents.month = range.startIndexPath.section
        range.correctStartMonthDate = self.calendar.date(byAdding: range.startmonthOffsetComponents, to: startOfMonthCache)
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
        selectedIndexPaths.append(range.startIndexPath)
        
        if range.startIndexPath.row == 0 || range.startIndexPath.row == range.startlastDayIndex {
            range.startmonthOffsetComponents.month = range.startIndexPath.section
            range.correctStartMonthDate = self.calendar.date(byAdding: range.startmonthOffsetComponents, to: startOfMonthCache)!
            range.startMonthInfo = self.getMonthInfo(for: range.correctStartMonthDate)!
            range.startlastDayIndex = range.startMonthInfo.firstDay + range.startMonthInfo.daysTotal
        }
    }
    
}
