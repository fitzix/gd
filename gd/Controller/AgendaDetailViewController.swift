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
    
    var glAgendaResp: GLAgendaResp = GLAgendaResp()
    
    // 原始数据
    var originBeginDate: String?
    var originEndDate: String?
    
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    @IBOutlet weak var editAgendaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originBeginDate = glAgendaResp.beginDate
        originEndDate = glAgendaResp.endDate
        
        loadForm()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        GLHttpUtil.shared.request(.getDetail, appendUrl: "/\(glAgendaResp.id!)") { [weak self] (resp: GLAgendaDetailResp) in
            guard let info = resp.info else {
                KRProgressHUD.showError(withMessage: "获取数据失败")
                return
            }
            
            KRProgressHUD.dismiss()
            
            if info.repeatType != 0 {
                self?.originBeginDate = info.beginDate
                self?.originEndDate = info.endDate
                info.beginDate = self?.glAgendaResp.beginDate
                info.endDate = self?.glAgendaResp.endDate
            }
            
            self?.glAgendaResp = info
            
            if let icon = info.userList?[0].icon {
                self?.detailImg.load(url: URL(string: icon)!)
            }
            // 判断是否可编辑
            let userInfo = GLUserInfo(JSONString: UserDefaults.standard.string(forKey: "GL_GD_USER_INFO")!)
            self?.editAgendaBtn.isEnabled = userInfo?.uid == info.uid
            
            self?.createUserLabel.text = "\(info.userList?[0].nickname ?? "--") 创建"
            self?.userCountLabel.text = "\(info.userList?.count ?? 0)人参与"
            self?.eventTypeLabel.text = "\(info.typeName ?? "日常")"
            
            let date = Date(fromString: info.beginDate!, format: .custom("YYYY-MM-dd"))
            
            self?.form.setValues([
                "title": info.title,
                "beginDate": "\(date?.toString(format: .custom("YYYY-MM-dd EE | ")) ?? "")\(info.beginTime?.prefix(5) ?? "") ~ \(info.endTime?.prefix(5) ?? "")",
                "remind": info.remind,
                "repeat": "\(info.repeatType!)",
                "digestContent": info.digestContent,
                "place": info.place
                ])
            self?.tableView.reloadData()
        }
    }
    
    func loadForm() {
        form
            +++ Section()
            <<< LabelRow ("title") {
                $0.title = "主题"
                $0.value = glAgendaResp.title
            }
            <<< LabelRow ("beginDate") {
                // TODO 判断空值
                $0.title = "时间"
            }
            <<< LabelRow ("plcae") {
                $0.title = "地址"
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
        let createAgendaController = self.storyboard?.instantiateViewController(withIdentifier: "AgendaViewController") as! AgendaViewController
        
        if glAgendaResp.repeatType != 0 {
            // 创建
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let editAll = UIAlertAction(title: "修改所有事件", style: .default) { [weak self] _ in
                self?.glAgendaResp.beginDate = self?.originEndDate
                self?.glAgendaResp.endDate = self?.originEndDate
                createAgendaController.repeatOpt = 2
                self?.toNext(vc: createAgendaController)
            }
            let editNext = UIAlertAction(title: "修改将来所有事件", style: .default) { [weak self] _ in
                createAgendaController.repeatOpt = 1
                self?.toNext(vc: createAgendaController)
            }
            let editCurrent = UIAlertAction(title: "修改当前事件", style: .default) { [weak self] _ in
                self?.glAgendaResp.repeatType = 0
                self?.toNext(vc: createAgendaController)
            }
            // 添加
            alertController.addAction(cancelAction)
            alertController.addAction(editAll)
            alertController.addAction(editNext)
            alertController.addAction(editCurrent)
            // 弹出
            self.present(alertController, animated: true, completion: nil)
            return
        }
        toNext(vc: createAgendaController)
    }
    
    
    func toNext(vc: AgendaViewController) {
        vc.glAgendaResp = glAgendaResp
        navigationController?.pushViewController(vc, animated: true)
    }
}
