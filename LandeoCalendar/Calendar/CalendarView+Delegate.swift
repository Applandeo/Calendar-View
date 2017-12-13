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
            
            if selectedIndexPaths.count > 1  {
                selectedIndexPaths.append(indexPath)
                selectedIndexPaths.removeAll()
            }
            
            if selectedIndexPaths.count == 1 {
                selectRange(indexPath: indexPath)
                
            }
            
            if selectedIndexPaths.isEmpty {
                selectedIndexPaths.append(indexPath)
            }
        }
        
    }
    
    func selectRange(indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
        
        let startIndex = selectedIndexPaths[0].row
        let endIndex = selectedIndexPaths[1].row

        let startIndexSection = selectedIndexPaths[0].section
        let endIndexSection = selectedIndexPaths[1].section
        
        var startIndexPath = IndexPath(row: startIndex, section: startIndexSection)
        var endIndexPath = IndexPath(row: endIndex, section: endIndexSection)
        
        if endIndexPath < startIndexPath {
            swap(&endIndexPath, &startIndexPath)
        }
        
        repeat {
            startIndexPath = startIndexPath.increaseRowByOne(sectionEnd: 30)
            selectedIndexPaths.append(startIndexPath)
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
