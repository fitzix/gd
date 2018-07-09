//
//  GLHttpUtil.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Alamofire

class GLHttpUtil: NSObject {
    
    static let shared = GLHttpUtil()
    
    let httpGateway = "http://192.168.3.194:15000"
    
    let headers: HTTPHeaders = [
        "Authorization": "a100",
        "Accept": "application/json"
    ]
    
    enum GLRequestURL: String {
        case getAgendaList = "/agenda/getList"
        case getDetail = "/agenda/getDetail"
        case createAgenda = "/agenda/create"
        case updateAgenda = "/agenda/update"
    }
    
    // 基础请求方法
    public func request<T: GLBaseResp>(_ url: GLRequestURL, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, appendUrl: String? = nil, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (T?) -> Void) {
        let req = Alamofire.request("\(httpGateway)\(url.rawValue)\(appendUrl ?? "")", method: method, parameters: parameters, encoding: encoding, headers: headers)
        print(req)
        req.responseObject { (response: DataResponse<T>) in
            guard let result = response.result.value, result.ok else {
                print("请求失败")
                completion(nil)
                return
            }
            completion(result)
        }
    }
    
    
}
