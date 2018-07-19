//
//  FirstViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper

class UserInfoViewController: FormViewController, AMapSearchDelegate  {
    
    var userInfo = LocalStore.getObject(key: .userInfo, object: GLUserInfo())
    
    var search = AMapSearchAPI()!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        let request = AMapPOIAroundSearchRequest()
        request.keywords = "金泰"
        print(request)
        search.aMapPOIAroundSearch(request)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        form
            +++ Section()
            <<< GLUserInfoRow {
                $0.value = GLUserModel(name: userInfo?.nickname, iconURL: userInfo?.icon)
            }
            +++ Section()
            <<< MultipleSelectorRow<String>("remind") {
                $0.title = "提醒设置"
                $0.options = ["0", "1", "2", "3", "4", "11", "12", "21", "22", "31"]
                $0.value = ["2","3"]
                $0.displayValueFor = { values in
                    return values?.map({ GLRemindType(rawValue: $0)!.title }).joined(separator: ",")
                }
                }.onPresent{ from, to in
                    
                    to.sectionKeyForValue = { option in
                        switch option {
                        case "0": return "不提醒"
                        default: return "提醒(可多选,如果选了不提醒则无效)"
                        }
                    }
                    to.selectableRowCellSetup = { cell,row in
                        row.title = GLRemindType(rawValue: row.title!)?.title
                    }
                }.cellUpdate({ (cell, row) in
                    if row.value!.contains("0") && row.value!.count > 1 {
                        row.value = ["0"]
                        row.updateCell()
                    }
                    if let values = row.value {
                        LocalStore.save(key: .userRemindTypes, info: values.joined(separator: ","))
                    }
                })
            // 账号退出
            +++ Section()
            <<< LabelRow () {
                $0.title = "退出当前登录"
                $0.cellStyle = .default
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.textColor = UIColor(red:0.97, green:0.39, blue:0.35, alpha:1.00)
                }).onCellSelection({ (cell, row) in

                    DispatchQueue.main.async{
                        // 创建
                        let alertController = UIAlertController(title: "提示", message: "你确定要离开？", preferredStyle:.alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        let okAction = UIAlertAction(title: "好的", style: .default) { _ in
                            LocalStore.logout()
                        }
                        // 添加
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        
                        // 弹出
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 8
        }
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 13
        }
        return 4
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        print(23333333)
    }
}

