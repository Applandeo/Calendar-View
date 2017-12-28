//
//  CalendarViewDataSource.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

extension CalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard self.startDateCache <= self.endDateCache else { return 0 }
        let firstDayOfMonth = self.calendar.firstDayOfMonth(from: startDateCache)
        self.startOfMonthCache = firstDayOfMonth
        
        if (self.startOfMonthCache ... self.endDateCache).contains(today) {
            let distanceFromTodayComponents = self.calendar.dateComponents([.month, .day], from: self.startOfMonthCache, to: today)
            self.todayIndexPath = IndexPath(item: distanceFromTodayComponents.day!, section: distanceFromTodayComponents.month!)
        }
        return self.calendar.dateComponents([.month], from: startDateCache, to: endDateCache).month! + 1
    }
    
    func getMonthInfo(for date: Date) -> (firstDay: Int, daysTotal: Int)? {
        var firstWeekdayOfMonthIndex = self.calendar.component(.weekday, from: date)
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7
        guard let rangeOfDaysInMonth: Range<Int> = self.calendar.range(of: .day, in: .month, for: date) else { return nil }
        let numberOfDaysInMonth = rangeOfDaysInMonth.upperBound - rangeOfDaysInMonth.lowerBound
        return (firstDay: firstWeekdayOfMonthIndex, daysTotal: numberOfDaysInMonth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = section
        
        guard let correctMonthForSectionDate = self.calendar.date(byAdding: monthOffsetComponents, to: startOfMonthCache) else { return 0 }
        guard let info = self.getMonthInfo(for: correctMonthForSectionDate) else { return 0 }
        
        self.monthInfoForSection[section] = info
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell_ID, for: indexPath) as? DayCell else { return DayCell() }
        guard let (firstDayIndex, numberOfDaysTotal) = self.monthInfoForSection[indexPath.section] else { return dayCell }
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - firstDayIndex, section: indexPath.section)
        let lastDayIndex = firstDayIndex + numberOfDaysTotal
        
        isCellInMonthRange(firstDayIndex, lastDayIndex, indexPath, dayCell, fromStartOfMonthIndexPath)
        dayCell.isSelected = selectedIndexPaths.contains(indexPath)
        updateHeaderDate(indexPath, collectionView)
        checkIfCellIsToday(dayCell, indexPath, firstDayIndex)
        countEventsForCell(indexPath, dayCell)
        
        return dayCell
    }
    
    fileprivate func updateHeaderDate(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        if indexPath.section == 0 && indexPath.item == 0 {
            self.scrollViewDidEndDecelerating(collectionView)
        }
    }
    
    fileprivate func isCellInMonthRange(_ firstDayIndex: Int, _ lastDayIndex: Int, _ indexPath: IndexPath, _ dayCell: DayCell, _ fromStartOfMonthIndexPath: IndexPath) {
        if (firstDayIndex..<lastDayIndex).contains(indexPath.item) {
            dayCell.textLabel.text = String(fromStartOfMonthIndexPath.item + 1)
            dayCell.isHidden = false
        } else {
            dayCell.textLabel.text = ""
            dayCell.isHidden = true
        }
    }
    
    fileprivate func checkIfCellIsToday(_ dayCell: DayCell, _ indexPath: IndexPath, _ firstDayIndex: Int) {
        if let index = todayIndexPath {
            dayCell.isToday = (index.section == indexPath.section && index.item + firstDayIndex == indexPath.item)
        }
    }
    
    fileprivate func countEventsForCell(_ indexPath: IndexPath, _ dayCell: DayCell) {
        if let eventsForDay = self.eventsByIndexPath[indexPath] {
            dayCell.eventsCount = eventsForDay.count
        } else {
            dayCell.eventsCount = 0
        }
    }
    
}

