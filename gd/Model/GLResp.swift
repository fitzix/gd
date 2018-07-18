//
//  GLBaseResp.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import ObjectMapper

class GLBaseResp: Mappable {
    
    var state: Int?
    var msg: String?
    var ok: Bool?
    
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


class GLAgendaResp: NSObject, NSCopying, Mappable {
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
    var repeatEndDate: String?
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
    
    required init?(map: Map) {}
    
    override init(){}
    
    init(beginDate: String?, beginTime: String?, candidatePoList: [GLCandidateResp]?, commentList: [GLCommentResp]?, conflict: Int?, deleteUserList: [GLUserResp]?, digestContent: String?, digestTitle: String?, endDate: String?, endTime: String?, id: Int?, place: String?, placeX: Int?, placeY: Int?, quitUserList: [GLUserResp]?, recordState: Int?, remind: String?, repeatEndDate: String?, repeatExcludeDates: String?, repeatType: Int?, specialContent: String?, specialId: Int?, title: String?, todayBeginTime: String?, todayEndTime: String?, type: Int?, typeName: String?, uid: Int?, userList: [GLUserResp]?, userNum: Int?, viewType: Int?) {
         self.beginDate = beginDate
         self.beginTime = beginTime
         self.candidatePoList = candidatePoList
         self.commentList = commentList
         self.conflict = conflict
         self.deleteUserList = deleteUserList
         self.digestContent = digestContent
         self.digestTitle = digestTitle
         self.endDate = endDate
         self.endTime = endTime
         self.id = id
         self.place = place
         self.placeX = placeX
         self.placeY = placeY
         self.quitUserList = quitUserList
         self.recordState = recordState
         self.remind = remind
         self.repeatEndDate = repeatEndDate
         self.repeatExcludeDates = repeatExcludeDates
         self.repeatType = repeatType
         self.specialContent = specialContent
         self.specialId = specialId
         self.title = title
         self.todayBeginTime = todayBeginTime
         self.todayEndTime = todayEndTime
         self.type = type
         self.typeName = typeName
         self.uid = uid
         self.userList = userList
         self.userNum = userNum
         self.viewType = viewType
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        return GLAgendaResp(beginDate: beginDate, beginTime: beginTime, candidatePoList: candidatePoList, commentList: commentList, conflict: conflict, deleteUserList: deleteUserList, digestContent: digestContent, digestTitle: digestTitle, endDate: endDate, endTime: endTime, id: id, place: place, placeX: placeX, placeY: placeY, quitUserList: quitUserList, recordState: recordState, remind: remind, repeatEndDate: repeatEndDate, repeatExcludeDates: repeatExcludeDates, repeatType: repeatType, specialContent: specialContent, specialId: specialId, title: title, todayBeginTime: todayBeginTime, todayEndTime: todayEndTime, type: type, typeName: typeName, uid: uid, userList: userList, userNum: userNum, viewType: viewType)
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

// OAUTH
class GLOauthInfo: Mappable {
    var token: String?
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        token <- map["token"]
    }
}

class GLOauthResp: GLBaseResp {
    var info: GLOauthInfo?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}

class GLUserInfo: Mappable{
    var uid: Int?
    var nickname: String?
    var icon: String?
    var beginTime: String?
    var endTime: String?
    var remind: Int?
    var viewType: Int?
    var token: String?
    var specialId: Int?
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        uid <- map["uid"]
        nickname <- map["nickname"]
        icon <- map["icon"]
        beginTime <- map["beginTime"]
        endTime <- map["endTime"]
        remind <- map["remind"]
        viewType <- map["viewType"]
        token <- map["token"]
        specialId <- map["specialId"]
    }
    init() {}
}

class GLUserInfoResp: GLBaseResp {
    var info: GLUserInfo?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}

// 更新事件返回 新的id
class GLUpdateAgendaResp: GLBaseResp {
    var info: Int?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}

// 事件地址
struct GLAgendaPlace: SuggestionValue {
    var place: String
    var placeX: Double
    var placeY: Double
    
    var suggestionString: String {
        return place
    }
    
    init(place: String, placeX: Double, placeY: Double) {
        self.place = place
        self.placeX = placeX
        self.placeY = placeY
    }
    
    init?(string stringValue: String) {
        return nil
    }
}
