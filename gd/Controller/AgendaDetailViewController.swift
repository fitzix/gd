//
//  AgendaDetailViewController.swift
//  gd
//
//  Created by fitz on 2018/6/29.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka
import KRProgressHUD

class AgendaDetailViewController: FormViewController {
    
    var agendaId = 0
    
    var glAgendaResp: GLAgendaResp?
    
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    @IBOutlet weak var editAgendaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadForm()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        GLHttpUtil.shared.request(.getDetail, appendUrl: "/\(agendaId)") { [weak self] (resp: GLAgendaDetailResp) in
            guard let info = resp.info else {
                KRProgressHUD.showError(withMessage: "获取数据失败")
                return
            }
            
            KRProgressHUD.dismiss()
            
            self?.glAgendaResp = info
            
            if let icon = info.userList?[0].icon {
                self?.detailImg.load(url: URL(string: icon)!)
            }
            self?.createUserLabel.text = "\(info.userList?[0].nickname ?? "--") 创建"
            self?.userCountLabel.text = "\(info.userList?.count ?? 0)人参与"
            self?.eventTypeLabel.text = "\(info.typeName ?? "日常")"
            
            let date = Date(fromString: info.beginDate!, format: .custom("YYYY-MM-dd"))
            
            self?.form.setValues([
                "title": info.title,
                "beginDate": "\(date?.toString(format: .custom("YYYY-MM-dd EE | ")) ?? "")\(info.beginTime?.prefix(5) ?? "") ~ \(info.endTime?.prefix(5) ?? "")",
                "remind": info.remind,
                "repeat": info.repeatType,
                "digestContent": info.digestContent
                ])
            self?.tableView.reloadData()
        }
    }
    
    func loadForm() {
        form
            +++ Section()
            <<< LabelRow ("title") {
                $0.title = "主题"
                $0.value = glAgendaResp?.title
            }
            <<< LabelRow ("beginDate") {
                // TODO 判断空值
                $0.title = "时间"
            }
            <<< LabelRow ("remind") {
                $0.title = "提醒"
                $0.displayValueFor = {
                    return $0?.components(separatedBy: ",").map({
                        if let temp = GLRemindType(rawValue: $0)?.title {
                            return temp
                        }
                        return "未知"
                    }).joined(separator: ",")
                }
            }
            
            <<< LabelRow ("repeat") {
                $0.title = "重复"
                $0.displayValueFor = {
                    if let indexStr = $0, let index = Int(indexStr) {
                        return GLRepeatType(rawValue: index)?.title
                    }
                    return ""
                }
            }
            
            <<< LabelRow () {
                $0.title = "摘要:"
                $0.value = ""
            }
            <<< TextAreaRow("digestContent") {
                $0.disabled = true
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    
    @IBAction func editAgendaAction(_ sender: UIButton) {
        guard let glAgendaResp = glAgendaResp else {
            return
        }
        
        let createAgendaController = self.storyboard?.instantiateViewController(withIdentifier: "AgendaViewController") as! AgendaViewController
        createAgendaController.glAgendaResp = glAgendaResp
        navigationController?.pushViewController(createAgendaController, animated: true)
    }
}
