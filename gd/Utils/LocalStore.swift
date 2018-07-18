//
//  LocalStore.swift
//  gd
//
//  Created by fitz on 2018/7/10.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import ObjectMapper

class LocalStore {
    enum GLStoreKey: String {
        case userToken = "GL_GD_TOKEN"
        case userInfo = "GL_GD_USER_INFO"
        case userRemindTypes = "GL_GD_REMIND_TYPES"
    }
    
    
    class var isLogin: Bool {
        get {
            return get(key: .userToken) != nil
        }
    }
    
    class func login(info: GLUserInfo) {
        save(key: .userToken, info: info.token)
        save(key: .userInfo, info: info)
        Switcher.updateRootVC()
    }
    
    class func logout() {
        GLAgendaDataUtil.shared.resetAll()
        UserDefaults.standard.removeObject(forKey: GLStoreKey.userInfo.rawValue)
        UserDefaults.standard.removeObject(forKey: GLStoreKey.userToken.rawValue)
        Switcher.updateRootVC()
    }
    
    class func save(key: GLStoreKey, info: Mappable) {
        if let str = info.toJSONString() {
            UserDefaults.standard.set(str, forKey: key.rawValue)
        }
    }
    
    class func save(key: GLStoreKey, info: String?) {
        if let str = info {
            UserDefaults.standard.set(str, forKey: key.rawValue)
        }
    }
    
    class func get(key: GLStoreKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    class func getObject<T: Mappable>(key: GLStoreKey, object: T) -> T?{
        if let objStr = get(key: key) {
            return T(JSONString: objStr)
        }
        return nil
    }
    
    class func initRemind() {
        guard let _ = get(key: .userRemindTypes) else {
            save(key: .userRemindTypes, info: "2,3")
            return
        }
    }
}
