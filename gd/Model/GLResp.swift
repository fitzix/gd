//
//  GLBaseResp.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import ObjectMapper

class GLBaseResp: Mappable {
    
    var state: Int!
    var msg: String!
    var ok: Bool!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        state <- map["state"]
        msg <- map["msg"]
        ok <- map["ok"]
    }
}

class GLCandidateResp: Mappable {
    var beginDate: String?
    var beginTime: String?
    var conflict: Int?
    var defaultValue: Int?
    var endDate: String?
    var endTime: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        beginDate <- map["beginDate"]
        beginTime <- map["beginTime"]
        conflict <- map["conflict"]
        defaultValue <- map["defaultValue"]
        endDate <- map["endDate"]
        endTime <- map["endTime"]
    }
}

class GLCommentResp: Mappable {
    var comment: String?
    var dt: String?
    var eventId: Int?
    var id: Int?
    var recordState: Int?
    var uid: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        dt <- map["dt"]
        eventId <- map["eventId"]
        id <- map["id"]
        recordState <- map["recordState"]
        uid <- map["uid"]
    }
}

class GLUserResp: Mappable {
    var icon: String?
    var nickname: String?
    var uid: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        icon <- map["icon"]
        nickname <- map["nickname"]
        uid <- map["uid"]
    }
}


class GLAgendaResp: Mappable {
    var beginDate: String?
    var beginTime: String?
    var candidatePoList: [GLCandidateResp]?
    var commentList: [GLCommentResp]?
    var conflict: Int?
    var deleteUserList: [GLUserResp]?
    var digestContent: String?
    var digestTitle: String?
    var endDate: String?
    var endTime: String?
    var id: Int?
    var place: String?
    var placeX: Int?
    var placeY: Int?
    var quitUserList: [GLUserResp]?
    var recordState: Int?
    var remind: String?
    var repeatEndDate: Date?
    var repeatExcludeDates: String?
    var repeatType: Int?
    var specialContent: String?
    var specialId: Int?
    var title: String?
    var todayBeginTime: String?
    var todayEndTime: String?
    var type: Int?
    var typeName: String?
    var uid: Int?
    var userList: [GLUserResp]?
    var userNum: Int?
    var viewType: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        beginDate <- map["beginDate"]
        beginTime <- map["beginTime"]
        candidatePoList <- map["candidatePoList"]
        commentList <- map["commentList"]
        conflict <- map["conflict"]
        deleteUserList <- map["deleteUserList"]
        digestContent <- map["digestContent"]
        digestTitle <- map["digestTitle"]
        endDate <- map["endDate"]
        endTime <- map["endTime"]
        id <- map["id"]
        place <- map["place"]
        placeX <- map["placeX"]
        placeY <- map["placeY"]
        quitUserList <- map["quitUserList"]
        recordState <- map["recordState"]
        remind <- map["remind"]
        repeatEndDate <- map["repeatEndDate"]
        repeatExcludeDates <- map["repeatExcludeDates"]
        repeatType <- map["repeatType"]
        specialContent <- map["specialContent"]
        specialId <- map["specialId"]
        title <- map["title"]
        todayBeginTime <- map["todayBeginTime"]
        todayEndTime <- map["todayEndTime"]
        type <- map["type"]
        typeName <- map["typeName"]
        uid <- map["uid"]
        typeName <- map["typeName"]
        userList <- map["userList"]
        userNum <- map["userNum"]
        viewType <- map["viewType"]
    }
    
}

// 事件列表
class GLAgendaListResp: GLBaseResp {
    var info: [GLAgendaResp]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}

// 事件详情
class GLAgendaDetailResp: GLBaseResp {
    var info: GLAgendaResp?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}
