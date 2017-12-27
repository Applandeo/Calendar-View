//
//  EventsLoader.swift
//  LandeoCalendar
//
//  Created by sebastian on 12.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//


import Foundation
import EventKit

protocol EventsLoaderProtocol {
    func load(from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]?) -> Void)
}

class EventsLoader : EventsLoaderProtocol {
        
    func load(from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]?) -> Void) {
        let q = DispatchQueue.main
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            return EventsLoader.store.requestAccess(to: EKEntityType.event, completion: {(granted, error) -> Void in
                guard granted else {
                    return q.async { onComplete(nil) }
                }
                EventsLoader.fetch(from: fromDate, to: toDate) { events in
                    q.async { onComplete(events) }
                }
            })
        }
        EventsLoader.fetch(from: fromDate, to: toDate) { events in
            q.async { onComplete(events) }
        }
        
    }
    
    private static func fetch(from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]) -> Void) {
        let predicate = store.predicateForEvents(withStart: fromDate, end: toDate, calendars: nil)
        let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        let events = store.events(matching: predicate).map {
            return CalendarEvent(
                title:      $0.title,
                startDate:  $0.startDate.addingTimeInterval(secondsFromGMTDifference),
                endDate:    $0.endDate.addingTimeInterval(secondsFromGMTDifference)
            )
        }
        onComplete(events)
    }
}

