//
//  EventKitUtil.swift
//  gd
//
//  Created by fitz on 2018/7/4.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import EventKit

class EventKitUtil {
    static let shared = EventKitUtil()
    
    let eventStore = EKEventStore()
    var holidayStore: [String: String] = [:]
    
    func getEvent() {
        eventStore.requestAccess(to: .event) { (success, err) in
            if success && err == nil {
                
                //获取本地日历
                let calendars = self.eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .subscription
                })
                let start = Date().adjust(.year, offset: -3)
                let end = Date().adjust(.year, offset: 4)
                let x = self.eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
                
                if let eV = self.eventStore.events(matching: x) as [EKEvent]? {
                    for i in eV {
                        self.holidayStore[i.startDate.toString(format: .isoDate)] = i.title
                    }
                }
                
            }
        }
    }
    
    func getHolidayTitle(date: Date) -> String {
        if let title = holidayStore[date.toString(format: .isoDate)] {
            return title
        }
        return ""
    }
}
