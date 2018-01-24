//
//  CalendarViewDataSource.swift
//  LandeoCalendar
//
//  Created by sebastian on 11.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

extension CalendarView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard calendarModel.startDate <= calendarModel.endDate else { return 0 }
        calendarModel.monthFirstDay = self.calendar.firstDayOfMonth(from: calendarModel.startDate)
        
        if (calendarModel.monthFirstDay ... calendarModel.endDate).contains(today) {
            let distanceFromTodayComponents = self.calendar.dateComponents([.month, .day], from: calendarModel.monthFirstDay, to: today)
            calendarModel.todayIndexPath = IndexPath(item: distanceFromTodayComponents.day!, section: distanceFromTodayComponents.month!)
        }
        return self.calendar.dateComponents([.month], from: calendarModel.startDate, to: calendarModel.endDate).month! + 1
    }
    
    func getMonthInfo(for date: Date) -> (firstDay: Int, daysTotal: Int)? {
        var firstWeekdayOfMonthIndex = self.calendar.component(.weekday, from: date)
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7
        guard let rangeOfDaysInMonth: Range<Int> = self.calendar.range(of: .day, in: .month, for: date) else { return nil }
        let numberOfDaysInMonth = rangeOfDaysInMonth.upperBound - rangeOfDaysInMonth.lowerBound
        return (firstDay: firstWeekdayOfMonthIndex, daysTotal: numberOfDaysInMonth)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = section
        
        guard let correctMonthForSectionDate = self.calendar.date(byAdding: monthOffsetComponents, to: calendarModel.monthFirstDay) else { return 0 }
        guard let info = self.getMonthInfo(for: correctMonthForSectionDate) else { return 0 }
        
        calendarModel.monthInfoForSection[section] = info
        return 42
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell_ID, for: indexPath) as? DayCell else { return DayCell() }
        guard let (firstDayIndex, numberOfDaysTotal) = calendarModel.monthInfoForSection[indexPath.section] else { return dayCell }
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - firstDayIndex, section: indexPath.section)
        let lastDayIndex = firstDayIndex + numberOfDaysTotal
        
        isCellInMonthRange(firstDayIndex, lastDayIndex, indexPath, dayCell, fromStartOfMonthIndexPath)
        dayCell.isSelected = calendarModel.selectedIndexPaths.contains(indexPath)
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
        if let index = calendarModel.todayIndexPath {
            dayCell.isToday = (index.section == indexPath.section && index.item + firstDayIndex == indexPath.item)
        }
    }
    
    fileprivate func countEventsForCell(_ indexPath: IndexPath, _ dayCell: DayCell) {
        if let eventsForDay = calendarModel.eventsByIndexPath[indexPath] {
            dayCell.eventsCount = eventsForDay.count
        } else {
            dayCell.eventsCount = 0
        }
    }
    
}
