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
//        selectedDates.remove(at: index)
        delegate?.calendar(self, didDeselectDate: date)
    }
    
    fileprivate func selectCell(date: Date, indexPath: IndexPath) {
        
//        if allowMultipleSelection {
//            selectedDates.removeAll()
//            selectedIndexPaths.removeAll()
//        }
//        selectedDates.append(date)
//        selectedIndexPaths.append(indexPath)
//        let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
//        delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
//
        
        
        
        if CalendarStyle.cellSelectionType == .range {
            let startIndexPath: IndexPath?
            let endIndexPath: IndexPath?
            
            if selectedIndexPaths.count > 1  {
                startIndexPath = indexPath
                selectedIndexPaths.append(startIndexPath!)
                selectedIndexPaths.removeAll()
            }
            
            if selectedIndexPaths.count == 1 {
                endIndexPath = indexPath
                selectRange(startIndexPath: selectedIndexPaths[0], endIndexPath: endIndexPath!, date: date)
            }
            
            if selectedIndexPaths.isEmpty {
                selectedIndexPaths.append(indexPath)
            }
        } else if CalendarStyle.cellSelectionType == .single {
            selectedDates.removeAll()
            selectedIndexPaths.removeAll()
            selectedDates.append(date)
            selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
        } else if CalendarStyle.cellSelectionType == .multiple {
            selectedDates.append(date)
            selectedIndexPaths.append(indexPath)
            let eventsForDaySelected = eventsByIndexPath[indexPath] ?? []
            delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected)
        }
    }
    
    func selectRange(startIndexPath: IndexPath, endIndexPath: IndexPath, date: Date) {
        selectedIndexPaths.append(endIndexPath)
        
        var startIndexPath = startIndexPath
        var endIndexPath = endIndexPath
        
        var startmonthOffsetComponents = DateComponents()
        var endMonthOffsetcomponents = DateComponents()
        
        startmonthOffsetComponents.month = startIndexPath.section
        endMonthOffsetcomponents.month = endIndexPath.section
        
        guard var correctStartMonthDate = self.calendar.date(byAdding: startmonthOffsetComponents, to: startOfMonthCache) else { return }
        guard let correctEndMonthDate = self.calendar.date(byAdding: endMonthOffsetcomponents, to: startOfMonthCache) else { return }
        
        guard var startMonthInfo = self.getMonthInfo(for: correctStartMonthDate) else { return  }
        guard let endMonthInfo = self.getMonthInfo(for: correctEndMonthDate) else { return }
        
        guard var startDate = dateFromIndexPath(startIndexPath) else { return }
        guard let endDate = dateFromIndexPath(endIndexPath) else { return }
        
        var startfirstDay = startMonthInfo.firstDay
        var startdaysTotal = startMonthInfo.daysTotal
        var startlastDayIndex = startfirstDay + startdaysTotal
        
        let endFirstDay = endMonthInfo.firstDay
        let endDaysTotal = endMonthInfo.daysTotal
        let endLastDayIndex = endFirstDay + endDaysTotal
        
        if endIndexPath < startIndexPath {
            swap(&endIndexPath, &startIndexPath)
        }
        
        repeat {
            startIndexPath = startIndexPath.increaseRowByOne(sectionEnd: startlastDayIndex)
            selectedIndexPaths.append(startIndexPath)
            
            if startIndexPath.row == 0 {
                startmonthOffsetComponents.month = startIndexPath.section
                correctStartMonthDate = self.calendar.date(byAdding: startmonthOffsetComponents, to: startOfMonthCache)!
                startMonthInfo = self.getMonthInfo(for: correctStartMonthDate)!
                startfirstDay = startMonthInfo.firstDay
                startdaysTotal = startMonthInfo.daysTotal
                startlastDayIndex = startfirstDay + startdaysTotal
            }
        } while (startIndexPath.isLesser(indexPath: endIndexPath))
        
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dateBeingSelected = self.dateFromIndexPath(indexPath) else { return false }
        
        if let delegate = self.delegate {
            return delegate.calendar(self, canSelectDate: dateBeingSelected)
        }
        return true // default
    }
    
    // MARK: UIScrollViewDelegate
    
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
        
        return self.calendar.date(byAdding: monthsOffsetComponents, to: self.startOfMonthCache);
    }
    
    func displayDateOnHeader(_ date: Date) {
        let month = self.calendar.component(.month, from: date) // get month
        let monthName = DateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        let year = self.calendar.component(.year, from: date)
        
        self.headerView.monthLabel.text = monthName + " " + String(year)
        self.displayDate = date
    }
}
