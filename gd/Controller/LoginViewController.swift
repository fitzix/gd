//
//  LoginViewController.swift
//  gd
//
//  Created by fitz on 2018/7/10.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import MonkeyKing
import KRProgressHUD
import Alamofire

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginAction(_ sender: UIButton) {
        MonkeyKing.weChatOAuthForCode { (code, error) in
            guard let code = code else {
                KRProgressHUD.showError(withMessage: "授权失败")
                return
            }
            KRProgressHUD.show()
            GLHttpUtil.shared.request(.oauthWx, service: .user_basic, parameters: ["code": code, "appid": 1008]){ (resp: GLOauthResp) in
                guard let info = resp.info else {
                    KRProgressHUD.showError(withMessage: "userbasic失败")
                    return
                }
                let headers: HTTPHeaders = ["Authorization": info.token!, "Accept": "application/json"]
                GLHttpUtil.shared.request(.appLogin, method: .post, encoding: JSONEncoding.default, headers: headers, completion: { (resp: GLUserInfoResp) in
                    guard let info = resp.info else {
                        KRProgressHUD.showError(withMessage: "app login失败")
                        return
                    }
                    KRProgressHUD.dismiss()
                    LocalStore.login(info: info)
                })
            }
        }
    }
}
