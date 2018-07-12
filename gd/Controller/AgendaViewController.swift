//
//  AgendaViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/22.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka
import DateHelper
import Alamofire
import KRProgressHUD

class AgendaViewController: FormViewController {
    
    var glAgendaResp: GLAgendaResp?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rowHeight = 40
        
        form
            +++ Section()

            <<< TextRow("title"){
                $0.title = "主题"
                $0.placeholder = "请输入你的主题(限10个字) 例如: 周会"
                if let title = glAgendaResp?.title {
                    $0.value = title
                }
                $0.add(rule: RuleMaxLength(maxLength: 15, msg: "主题长度不能超过15个"))
                $0.add(rule: RuleRequired(msg: "主题不能为空"))
                $0.validationOptions = .validatesOnChange
                }
            
            <<< SegmentedRow<Int>("type") {
                $0.title = "性质"
                $0.options = [0, 1, 2, 3]
                $0.displayValueFor = { type in
                    return GLAgendaType(rawValue: type!)?.title
                }
                if let typeIndex = glAgendaResp?.type {
                    $0.value = typeIndex
                } else {
                    $0.value = $0.options?.first
                }
            }
            <<< DateTimeRow("beginDate"){
                $0.title = "开始时间"
                if let glAgendaResp = glAgendaResp {
                    if let startTime = glAgendaResp.beginTime {
                        $0.value = Date(fromString: "\(glAgendaResp.beginDate!) \(startTime)", format: .custom("YYYY-MM-dd HH:mm:ss"))
                    } else {
                        // TODO null 取备选时间
                        $0.value = Date(fromString: "", format: .isoDate)
                    }
                } else{
                    
                    $0.value = Date().dateFor(.nearestHour(hour: 2))
                }
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd EE | HH:mm"
                $0.dateFormatter = formatter
                }.cellUpdate({ (cell, row) in
                    let endDateRow: TimeRow? = self.form.rowBy(tag: "endDate")
                    endDateRow?.minimumDate = row.value
                }).cellSetup({ (cell, row) in
                    cell.datePicker.minuteInterval = 15
                })
            <<< TimeRow("endDate"){
                $0.title = "结束时间"
                if let glAgendaResp = glAgendaResp, let endTime = glAgendaResp.endTime {
                    $0.value = Date(fromString: "\(glAgendaResp.endDate!) \(endTime)", format: .custom("YYYY-MM-dd HH:mm:ss"))
                } else {
                    $0.value = Date().dateFor(.nearestHour(hour: 2)).adjust(.hour, offset: 1)
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                $0.dateFormatter = formatter
                }.cellSetup({ (cell, row) in
                    cell.datePicker.minuteInterval = 15
                })
            //            <<< LocationRow(){
            //                $0.title = "LocationRow"
            //                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
            //            }
            
            <<< MultipleSelectorRow<String>("remind") {
                $0.title = "提醒设置"
                $0.options = ["0", "1", "2", "3", "4", "5"]
                if let glAgendaResp = glAgendaResp, let reminds = glAgendaResp.remind {
                    $0.value = Set(reminds.components(separatedBy: ","))
                } else if let reminds = LocalStore.get(key: "GL_GD_REMIND") {
                    $0.value = Set(reminds.components(separatedBy: ","))
                }
                
                $0.displayValueFor = { values in
                    return values?.map({
                        if let temp = GLRemindType(rawValue: $0)?.title {
                            return temp
                        }
                        return "未知"
                    }).joined(separator: ",")
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
                    if let values = row.value {
                        if values.contains("0") && values.count > 1 {
                            row.value = ["0"]
                            row.updateCell()
                        }
                    }
                })
            
            <<< PickerInputRow<Int>("repeatType"){
                $0.title = "重复"
                $0.options = [0, 1, 2, 3, 4]
                $0.displayValueFor = { type in
                    return GLRepeatType(rawValue: type!)?.title
                }
                
                if let typeIndex = glAgendaResp?.repeatType {
                    $0.value = typeIndex
                } else {
                    $0.value = $0.options.first
                }
            }
            <<< LabelRow() {
                $0.title = "摘要:"
                $0.value = ""
                }
            
            <<< TextAreaRow("digestContent") {
                $0.placeholder = "请输入你的摘要\n例如: 1.讨论产品设计风格\n2.确定产品风格"
                if let value = glAgendaResp?.digestContent {
                    $0.value = value
                }
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
            }
            tableView.tableFooterView = UIView()
    }



    @IBAction func removeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        let valid = form.validate()
        
        
        if valid.isEmpty {
            var values = form.values()
            let appendUrl = "/\(glAgendaResp!.id!)"
            
            let beginDate = (values["beginDate"] as? Date)?.toString(format: .custom("YYYY-MM-dd HH:mm:ss"))
            values["beginDate"] = beginDate?.prefix(10)
            values["beginTime"] = beginDate?.suffix(8)
            values["endDate"] = values["beginDate"]
            values["endTime"] = (form.values()["endDate"] as? Date)?.toString(format: .custom("HH:mm:ss"))
            values["remind"] = (form.values()["remind"] as? Set<String>)?.joined(separator: ",")
            
            KRProgressHUD.show()
            GLHttpUtil.shared.request(.updateAgenda, method: .post, parameters: values, appendUrl: appendUrl, encoding: JSONEncoding.default) { [weak self] (resp: GLBaseResp) in
                if !resp.ok! {
                    KRProgressHUD.showError(withMessage: resp.msg)
                    return
                }
                KRProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            KRProgressHUD.showWarning(withMessage: valid.first?.msg)
        }
    }
}
