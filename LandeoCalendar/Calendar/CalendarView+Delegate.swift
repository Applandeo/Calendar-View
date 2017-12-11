//
//  CalendarView+Delegate.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dateBeingSelected = self.dateFromIndexPath(indexPath) else { return false}
        
        if let delegate = self.delegate {
            return delegate.calendar(self, canSelectDate: dateBeingSelected)
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = self.dateFromIndexPath(indexPath) else { return }
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            delegate?.calendar(self, didDeselectDate: date)
            selectedIndexPaths.remove(at: index)
            selectedDatesByUser.remove(at: index)
        } else {
            selectedDatesByUser.append(date)
            selectedIndexPaths.append(indexPath)
            
            let eventsForDaySelected = eventsByIndexPath[indexPath]
            //delegate?.calendar(self, didSelectDate: date, withEvents: eventsForDaySelected!)
        }
        
        self.calendarView.reloadData()
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
    
    func checkCollectionViewPosition(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        if indexPath.section == 0 && indexPath.item == 0 {
            self.scrollViewDidEndDecelerating(collectionView)
        }
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
        case .horizontal:   page = Int(floor(self.calendarView.contentOffset.x / self.calendarView.bounds.size.width))
        case .vertical:     page = Int(floor(self.calendarView.contentOffset.y / self.calendarView.bounds.size.height))
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
