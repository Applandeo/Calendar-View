//
//  CalendarViewDataSource.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import Foundation
import UIKit

extension CalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let startDate = startCalendarDate
        let endDate = endCalendarDate
        let startOfMonthCache = Date()
        
        var firstDayOfStartMonth = self.calendar.dateComponents([.era, .year, .month], from: startDate)
        firstDayOfStartMonth.day = 1
        
        let dateFromDayOneComponents = self.calendar.date(from: firstDayOfStartMonth)!
        
        self.startOfMonthCache = dateFromDayOneComponents
        
        let today = Date()
        
        if (self.startOfMonthCache ... endDate).contains(today) {
            
            let distanceFromTodayComponents = self.calendar.dateComponents([.month, .day], from: startOfMonthCache, to: today)
            
            self.todayIndexPath = IndexPath(item: distanceFromTodayComponents.day!, section: distanceFromTodayComponents.month!)
            
        }
        
        // if we are for example on the same month and the difference is 0 we still need 1 to display it
        return self.calendar.dateComponents([.month], from: startDate, to: endDate).month! + 1
        
    }
    
    internal func getMonthInfo(for date: Date) -> (firstDay: Int, daysTotal: Int)? {
        
        var firstWeekdayOfMonthIndex    = self.calendar.component(.weekday, from: date)
        firstWeekdayOfMonthIndex        = firstWeekdayOfMonthIndex - 1 // firstWeekdayOfMonthIndex should be 0-Indexed
        firstWeekdayOfMonthIndex        = (firstWeekdayOfMonthIndex + 6) % 7 // push it modularly to take it back one day where the first day is Monday instead of Sunday
        
        guard let rangeOfDaysInMonth:Range<Int> = self.calendar.range(of: .day, in: .month, for: date) else { return nil }
        
        let numberOfDaysInMonth         = rangeOfDaysInMonth.upperBound - rangeOfDaysInMonth.lowerBound
        
        return (firstDay: firstWeekdayOfMonthIndex, daysTotal: numberOfDaysInMonth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = section;
        
        guard
            let correctMonthForSectionDate = self.calendar.date(byAdding: monthOffsetComponents, to: startOfMonthCache),
            let info = self.getMonthInfo(for: correctMonthForSectionDate) else { return 0 }
        
        self.monthInfoForSection[section] = info
        
        return 42
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CalendarCellID, for: indexPath) as! CalendarViewCell
        
        guard let (firstDayIndex, numberOfDaysTotal) = self.monthInfoForSection[indexPath.section] else { return dayCell }
        
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - firstDayIndex, section: indexPath.section) // if the first is wednesday, add 2
        
        let lastDayIndex = firstDayIndex + numberOfDaysTotal
        
        if (firstDayIndex..<lastDayIndex).contains(indexPath.item) { // item within range from first to last day
            
            dayCell.textLabel.text = String(fromStartOfMonthIndexPath.item + 1)
            dayCell.isHidden = false
            
        }
        else {
            dayCell.textLabel.text = ""
            dayCell.isHidden = true
        }
        
        dayCell.isSelected = selectedIndexPaths.contains(indexPath)
        
        if indexPath.section == 0 && indexPath.item == 0 {
            self.scrollViewDidEndDecelerating(collectionView)
        }
        
        if let idx = todayIndexPath {
            dayCell.isToday = (idx.section == indexPath.section && idx.item + firstDayIndex == indexPath.item)
        }
        
        if let eventsForDay = self.eventsByIndexPath[indexPath] {
            dayCell.eventsCount = eventsForDay.count
        } else {
            dayCell.eventsCount = 0
        }
        
        return dayCell
    }
    
}



