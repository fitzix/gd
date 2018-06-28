//
//  GLHttpUtil.swift
//  gd
//
//  Created by fitz on 2018/6/26.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Alamofire
import PKHUD

class GLHttpUtil: NSObject {
    
    static let shared = GLHttpUtil()
    
    let httpGateway = "http://192.168.3.194:15000"
    
    let headers: HTTPHeaders = [
        "Authorization": "a200",
        "Accept": "application/json"
    ]
    
    enum GLRequestURL: String {
        case getAgendaList = "/agenda/getList"
        case getDetail = "/agenda/getDetail"
    }
    
    
    public func request<T: GLBaseResp>(_ url: GLRequestURL, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, appendUrl: String? = nil, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (T?) -> Void) {
        
        HUD.show(.progress)
        
        
        let req = Alamofire.request("\(httpGateway)\(url.rawValue)\(appendUrl ?? "")", method: method, parameters: parameters, encoding: encoding, headers: headers)
        print("发送请求: \(req)")
        
        req.responseObject { (response: DataResponse<T>) in
            guard let result = response.result.value, result.ok else {
                HUD.flash(.error, delay: 1.0)
                print("请求出错了")
                completion(nil)
                return
            }
            HUD.hide()
            completion(result)
        }
    }
    
    // 构造事件列表返回结构
    class func flatAgendaList(dataList: [GLAgendaResp]) -> [[GLAgendaResp]] {
        let monthKeys = Array(Set(dataList.compactMap{ $0.beginDate?.prefix(7) })).sorted(by: <)
        var result = [[GLAgendaResp]]()
        
        monthKeys.forEach {
            let tempKey = $0
            let tempList = dataList.filter{ $0.beginDate?.prefix(7) == tempKey }
            result.append(tempList)
        }
        return result
    }
}
