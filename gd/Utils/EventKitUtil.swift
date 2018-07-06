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
    
    //事件集合
    var events:[EKEvent] = []
    var holidayStore: [String: String] = [:]
    
    
    func getEvent() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (success, err) in
            if success && err == nil {
                //获取本地日历
                let calendars = eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .subscription
                })
                
                for i in stride(from: -3, to: 3, by: 3) {
                    let start = Date().adjust(.year, offset: i)
                    let end = start.adjust(.year, offset: 3)

                    let temp = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
                    if let eV = eventStore.events(matching: temp) as [EKEvent]? {
                        self.events.append(contentsOf: eV)
                        for i in eV {
                            self.holidayStore[i.startDate.toString(format: .isoDate)] = i.title
                        }
                    }
                }
            }
        }
    }
    
    func getEvent(start: Date, end: Date) -> [GLAgendaResp] {
        var result: [GLAgendaResp] = []
        let event = events.filter { $0.startDate.compare(.isEarlier(than: end)) && $0.startDate.compare(.isLater(than: start)) }
        
        for i in event {
            let temp = GLAgendaResp()
            let startStr = i.startDate.toString(format: .custom("YYYY-MM-dd HH:mm"))
            let endStr = i.endDate.toString(format: .custom("YYYY-MM-dd HH:mm"))
            temp.beginDate = String(startStr.prefix(10))
            temp.beginTime = String(startStr.suffix(5))
            temp.endDate = String(endStr.prefix(10))
            temp.endTime = String(endStr.suffix(5))
            temp.title = i.title
            result.append(temp)
        }
        return result
    }
    
    
    func getHolidayTitle(date: Date) -> String {
        if let title = holidayStore[date.toString(format: .isoDate)] {
            return title
        }
        return LunarUtil.shared.string(from:date)
    }
}
