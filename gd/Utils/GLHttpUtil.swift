//
//  GLHttpUtil.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Alamofire
import KRProgressHUD

class GLHttpUtil: NSObject {
    
    static let shared = GLHttpUtil()
    
    let httpGateway = "https://test.gw.leuok.com"
    
    enum GLService: String {
        case gd = "/guandao"
        case user_basic = "/gl-ms-user-basic"
    }
    
    var GLHeaders: HTTPHeaders? {
        get {
            if let token = UserDefaults.standard.string(forKey: "GL_GD_TOKEN") {
                return [ "Authorization": token, "Accept": "application/json" ]
            }
            return nil
        }
    }
    
    enum GLRequestURL: String {
        case getAgendaList = "/agenda/getList"
        case getDetail = "/agenda/getDetail"
        case createAgenda = "/agenda/create"
        case updateAgenda = "/agenda/update"
        case appLogin = "/user/appLogin"
        
        // user-basic
        case oauthWx = "/oauth/android/wx"
    }
    
    // 基础请求方法
    public func request<T: GLBaseResp>(_ url: GLRequestURL, service:GLService = .gd,  method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, appendUrl: String? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, addMask: Bool = true, completion: @escaping (T) -> Void) {
        var localHeader = headers
        if headers == nil {
            localHeader = GLHeaders
        }
        
        let req = Alamofire.request("\(httpGateway)\(service.rawValue)\(url.rawValue)\(appendUrl ?? "")", method: method, parameters: parameters, encoding: encoding, headers: localHeader)
        print(req)
        debugPrint(req)
        if addMask { KRProgressHUD.show() }
        req.responseObject { (response: DataResponse<T>) in
            guard let result = response.result.value, let state = result.state  else {
                KRProgressHUD.showError(withMessage: "请求失败")
                print("请求失败")
                return
            }
            if state == -6 {
                KRProgressHUD.showError(withMessage: "重新登录")
                LocalStore.logout()
                return
            }
            completion(result)
        }
    }
    
    
}
