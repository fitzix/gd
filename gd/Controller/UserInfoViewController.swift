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

class UserInfoViewController: FormViewController  {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var userInfo = GLUserInfo(JSONString: UserDefaults.standard.string(forKey: "GL_GD_USER_INFO")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let iconUrl = userInfo?.icon {
            iconImage.load(url: URL(string: iconUrl)!)
        }
        nicknameLabel.text = userInfo?.nickname
        form
            +++ Section()
            <<< MultipleSelectorRow<String>("remind") {
                $0.title = "提醒设置"
                $0.options = ["0", "1", "2", "3", "4", "5"]
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
                        if let values = row.value {
                            LocalStore.save(key: "GL_GD_REMIND", info: values.joined(separator: ","))
                        }
                        row.updateCell()
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
}

