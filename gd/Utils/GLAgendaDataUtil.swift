//
//  GLAgendaDataUtil.swift
//  gd
//
//  Created by fitz on 2018/7/6.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import KRProgressHUD

class GLAgendaDataUtil {
    static let shared = GLAgendaDataUtil()
    typealias GLCalenderTaskDidSelect = (_ id: Int) -> Void
    
    
    var agendaList: [GLAgendaResp] = []
    
    // 后端返回事件列表 key为事件id
    var agendaDic: [Int: GLAgendaResp] = [:]
    // 事件列表页面数据
//    var agendaTableView:
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isInit = true
    
    var taskListDidSelect: GLCalenderTaskDidSelect?
    
    var agendaMap: [String:[GLAgendaResp]] = [:]
    
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
            self?.agendaList.append(contentsOf: info)
            DispatchQueue.global(qos: .default).async {
                self?.flatAgendaToMap()
            }
            completion(true)
        }
    }
    
//    func appendAgendaDic(start: Date, info: [GLAgendaResp]) {
//        let requestEndDate = start.adjust(.year, offset: 1)
//        var repeatData: [GLAgendaResp] = []
//        info.forEach {
//            agendaDic[$0.id!] = $0
//            let beginDate = Date(fromString: $0.beginDate!, format: .isoDate)!
//            let endDate = Date(fromString: $0.endDate!, format: .isoDate)
//
//            switch $0.repeatType {
//            case 0:
//                return
//            case 1:
//                for index in 1...Int(beginDate.since(requestEndDate, in: .day)) {
//
//                }
//            }
//        }
//    }
    
    
    func flatAgendaToMap() {
        let monthKeys = Array(Set(agendaList.compactMap{ $0.beginDate?.prefix(10) }))
        var result = [String:[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = agendaList.filter{ $0.beginDate?.prefix(10) == tempKey }
            result[String(tempKey)] = tempList
        }
        agendaMap = result
    }
    
    // 构造事件列表返回结构
    func flatAgendaList() -> [[GLAgendaResp]] {
        let monthKeys = Array(Set(agendaList.compactMap{ $0.beginDate?.prefix(7) })).sorted(by: <)
        var result = [[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = agendaList.filter{ $0.beginDate?.prefix(7) == tempKey }
            result.append(tempList)
        }
        return result
    }
    
    
}
