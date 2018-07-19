//
//  GLAgendaDataUtil.swift
//  gd
//
//  Created by fitz on 2018/7/6.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import KRProgressHUD
import DateHelper

class GLAgendaDataUtil {
    static let shared = GLAgendaDataUtil()
    typealias GLCalenderTaskDidSelect = (_ id: Int, _ curBegin: String, _ curEnd: String) -> Void
    typealias GLLocationRowKeyChange = (_ key: String) -> Void
    
    // KEY 为事件ID 所有事件
    var agendaDic: [Int: [GLAgendaResp]] = [:]
    
    // 事件列表页面数据
    var agendaTableData: [[GLAgendaResp]] = []
    // 日历内事件数据
    var agendaCalenderData: [String:[GLAgendaResp]] = [:]
    
    var startDate: Date = Date().dateFor(.startOfMonth)
    var endDate: Date = Date().dateFor(.startOfMonth)
    var isInit = true
    
    // 返回是否需要刷新数据
    var needRefresh = true
    var hasNewData = false
    
    // 日历内事件列表点击回调
    var taskListDidSelect: GLCalenderTaskDidSelect?
    var locationRowKeyChange: GLLocationRowKeyChange?
    
    func loadData(after: Bool = true, completion: @escaping (_ succeed: Bool) -> Void = {_ in }) {
        var requestDate = endDate
        
        if !after {
            requestDate = startDate.adjust(.year, offset: -1)
            if isInit {
                requestDate = startDate
                endDate = requestDate.adjust(.year, offset: 1)
                isInit = false
            }
        }
        
        GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": 5, "date": requestDate.toString(format: .isoDate)], addMask: false) { [weak self] (resp: GLAgendaListResp) in
            guard var info = resp.info else {
                completion(false)
                return
            }
            
            if after {
                self?.endDate = (self?.endDate.adjust(.year, offset: 1))!
            } else {
                self?.startDate = requestDate
            }
            
            let holiday = EventKitUtil.shared.getEvent(start: requestDate, end: requestDate.adjust(.year, offset: 1))
            if holiday.count > 0 {
                info.append(contentsOf: holiday)
            }
            self?.appendAgendaDic(after: after, start: requestDate, info: info)
            completion(true)
        }
    }
    
    // 去重存储数据 计算重复事件
    func appendAgendaDic(after: Bool, start: Date, info: [GLAgendaResp]) {
        var requestEndDate = start.adjust(.year, offset: 1)
        var repeatData: [GLAgendaResp] = []
        info.forEach {
            if $0.repeatType != 0 {
                var beginDate = Date(fromString: $0.beginDate!, format: .isoDate)
                let repeatEndDate = Date(fromString: $0.repeatEndDate!, format: .isoDate)!
                if repeatEndDate.compare(.isEarlier(than: requestEndDate)) {
                    requestEndDate = repeatEndDate
                }
                if beginDate!.compare(.isEarlier(than: start)) {
                    beginDate = start
                }

                switch $0.repeatType {
                case 0:
                    return
                case 1:
                    for index in 0..<Int(requestEndDate.since(beginDate!, in: .day)) {
                        let temp = $0.copy() as! GLAgendaResp
                        temp.beginDate = beginDate?.adjust(.day, offset: index).toString(format: .isoDate)
                        temp.endDate = beginDate?.adjust(.day, offset: index + 1).toString(format: .isoDate)
                        repeatData.append(temp)
                    }
                case 2:
                    for index in 0..<Int(requestEndDate.since(beginDate!, in: .week)) {
                        let temp = $0.copy() as! GLAgendaResp
                        temp.beginDate = beginDate?.adjust(.week, offset: index).toString(format: .isoDate)
                        temp.endDate = beginDate?.adjust(.week, offset: index + 1).toString(format: .isoDate)
                        repeatData.append(temp)
                    }
                case 3:
                    for index in 0..<Int(requestEndDate.since(beginDate!, in: .month)) {
                        let temp = $0.copy() as! GLAgendaResp
                        temp.beginDate = beginDate?.adjust(.month, offset: index).toString(format: .isoDate)
                        temp.endDate = beginDate?.adjust(.month, offset: index + 1).toString(format: .isoDate)
                        repeatData.append(temp)
                    }
                case 4:
                    for index in 0..<Int(requestEndDate.since(beginDate!, in: .year)) {
                        let temp = $0.copy() as! GLAgendaResp
                        temp.beginDate = beginDate?.adjust(.year, offset: index).toString(format: .isoDate)
                        temp.endDate = beginDate?.adjust(.year, offset: index + 1).toString(format: .isoDate)
                        repeatData.append(temp)
                    }
                default: break
                }
            } else {
                repeatData.append($0)
            }
        }
    let tableResult = flatAgendaList(info: repeatData)
        
    if after {
        agendaTableData.append(contentsOf: tableResult)
    } else {
        agendaTableData.insert(contentsOf: tableResult, at: 0)
    }
        
    DispatchQueue.global(qos: .default).async {
        self.flatAgendaToMap(info: repeatData)
    }
}
    
    // 日历内事件处理
    func flatAgendaToMap(info: [GLAgendaResp]) {
        let monthKeys = Array(Set(info.compactMap{ $0.beginDate?.prefix(10) }))
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = info.filter{ $0.beginDate?.prefix(10) == tempKey }
            agendaCalenderData[String(tempKey)] = tempList
        }
    }
    
    // 构造事件列表返回结构
    func flatAgendaList(info: [GLAgendaResp]) -> [[GLAgendaResp]] {
        let sortedInfo = info.sorted { return $0.beginDate! < $1.beginDate! }
        let monthKeys = Array(Set(info.compactMap{ $0.beginDate?.prefix(7) })).sorted(by: <)
        var result = [[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = sortedInfo.filter{ $0.beginDate?.prefix(7) == tempKey }
            result.append(tempList)
        }
        return result
    }
    
    func resetAll() {
        isInit = true
        needRefresh = true
        startDate = Date().dateFor(.startOfMonth)
        endDate = startDate
        
        agendaTableData = []
        agendaCalenderData = [:]
    }
    
    func rebuildData(start: Date) {
        resetAll()
        
        startDate = start.dateFor(.startOfMonth)
        endDate = startDate
    }
}
