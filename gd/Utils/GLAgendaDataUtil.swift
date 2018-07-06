//
//  GLAgendaDataUtil.swift
//  gd
//
//  Created by fitz on 2018/7/6.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import PKHUD

class GLAgendaDataUtil {
    static let shared = GLAgendaDataUtil()
    var agendaList: [GLAgendaResp] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isInit = true
    
    var agendaArray: [[GLAgendaResp]] {
        get{
           return GLHttpUtil.flatAgendaList(dataList: agendaList)
        }
    }
    
//    var agendaMap: [String:[GLAgendaResp]] {
//        get {
//
//        }
//    }
    
    func loadData(after: Bool = true, completion: @escaping (_ succeed: Bool) -> Void) {
        var requestDate = endDate
        
        if !after {
            requestDate = startDate.adjust(.year, offset: -1)
            if isInit {
                requestDate = startDate
                endDate = requestDate.adjust(.year, offset: 1)
                isInit = false
            }
        }
        
        GLHttpUtil.shared.request(.getAgendaList, parameters: ["viewType": 5, "date": requestDate.toString(format: .isoDate)]) { [weak self] (resp: GLAgendaListResp?) in
            guard let resp = resp, var info = resp.info else {
                HUD.flash(.labeledError(title: "请求数据失败", subtitle: nil), delay: 1)
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
            completion(true)
        }
    }
    
    func flatAgendaToMap(dataList: [GLAgendaResp]) -> [String:[GLAgendaResp]] {
        let monthKeys = Array(Set(dataList.compactMap{ $0.beginDate?.prefix(7) }))
        var result = [String:[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = dataList.filter{ $0.beginDate?.prefix(7) == tempKey }
            result[String(tempKey)] = tempList
        }
        return result
    }
}
