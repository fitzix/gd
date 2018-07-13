//
//  LocalStore.swift
//  gd
//
//  Created by fitz on 2018/7/10.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

class LocalStore {
    
    class func login(info: GLUserInfo) {
        UserDefaults.standard.set(info.token, forKey: "GL_GD_TOKEN")
        UserDefaults.standard.set(info.toJSONString(), forKey: "GL_GD_USER_INFO")
        Switcher.updateRootVC()
    }
    
    class func logout() {
        GLAgendaDataUtil.shared.resetAll()
        UserDefaults.standard.removeObject(forKey: "GL_GD_USER_INFO")
        UserDefaults.standard.removeObject(forKey: "GL_GD_TOKEN")
        Switcher.updateRootVC()
    }
    
    class func save(key: String, info: String) {
        UserDefaults.standard.set(info, forKey: key)
    }
    
    class func get(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
