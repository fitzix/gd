//
//  AgendaDetailViewController.swift
//  gd
//
//  Created by fitz on 2018/6/29.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka

class AgendaDetailViewController: FormViewController {
    
    var glAgendaResp: GLAgendaResp?
    
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    @IBOutlet weak var editAgendaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        form
            +++ Section()
            <<< LabelRow () {
                $0.title = "主题"
                $0.value = glAgendaResp?.title
            }
            <<< LabelRow () {
                // TODO 判断空值
                $0.title = "时间"
                let date = Date(fromString: glAgendaResp!.beginDate!, format: .custom("YYYY-MM-dd"))
                $0.value = "\(date?.toString(format: .custom("YYYY-MM-dd EE | ")) ?? "")\(glAgendaResp?.beginTime?.prefix(5) ?? "") ~ \(glAgendaResp?.endTime?.prefix(5) ?? "")"
            }
            <<< LabelRow () {
                $0.title = "提醒"
                if let typeIndex = glAgendaResp?.remind {
                   $0.value = typeIndex.components(separatedBy: ",").map({
                    if let temp = GLRemindType(rawValue: $0)?.title {
                        return temp
                    }
                    return "未知"
                   }).joined(separator: ",")
                }
            }
            
            <<< LabelRow () {
                $0.title = "重复"
                if let typeIndex = glAgendaResp?.repeatType {
                    $0.value = GLRepeatType(rawValue: typeIndex)?.title
                }
            }
            
            
            <<< LabelRow () {
                $0.title = "摘要:"
                $0.value = ""
            }
            <<< TextAreaRow() {
                $0.value = glAgendaResp?.digestContent
                $0.disabled = true
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }
        tableView.tableFooterView = UIView()
    }
    
    func loadData() {
        if let icon = glAgendaResp?.userList?[0].icon {
            detailImg.load(url: URL(string: icon)!)
        }
        createUserLabel.text = "\(glAgendaResp?.userList?[0].nickname ?? "--") 创建"
        userCountLabel.text = "\(glAgendaResp?.userList?.count ?? 0)人参与"
        eventTypeLabel.text = "\(glAgendaResp?.typeName ?? "日常")"
    }
    
    @IBAction func editAgendaAction(_ sender: UIButton) {
        let createAgendaController = self.storyboard?.instantiateViewController(withIdentifier: "AgendaViewController") as! AgendaViewController
        createAgendaController.glAgendaResp = glAgendaResp
        createAgendaController.isToCreate = false
        navigationController?.pushViewController(createAgendaController, animated: true)
    }
}
