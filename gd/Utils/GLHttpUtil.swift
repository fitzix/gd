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
        "Authorization": "a200",
        "Accept": "application/json"
    ]
    
    enum GLRequestURL: String {
        case getAgendaList = "/agenda/getList"
    }
    
    
    public func request(_ url: GLRequestURL, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default) -> Alamofire.DataRequest {
        return Alamofire.request( httpGateway + url.rawValue, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
}
