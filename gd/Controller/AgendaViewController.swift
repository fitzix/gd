//
//  AgendaViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/22.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka

class AgendaViewController: FormViewController {
    
    var glAgendaResp: GLAgendaResp?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        form
            +++ Section()

            <<< TextRow("title"){
                $0.title = "主题"
                $0.placeholder = "请输入你的主题(限10个字) 例如: 周会"
                if let title = glAgendaResp?.title {
                    $0.value = title
                }
                $0.add(rule: RuleMaxLength(maxLength: 10))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                })
            
            
            <<< SegmentedRow<String>("type") {
                $0.title = "性质"
                $0.options = GLAgendaType.getTitleValues()
                if let typeIndex = glAgendaResp?.type {
                    $0.value = GLAgendaType(rawValue: typeIndex)?.title
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
                        $0.value = Date(fromString: "", format: .isoDate)
                    }
                } else{
                    $0.value = Date()
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd EE | HH:mm"
                $0.dateFormatter = formatter
            }
            <<< TimeRow("endDate"){
                $0.title = "结束时间"
                if let glAgendaResp = glAgendaResp, let endTime = glAgendaResp.endTime {
                    $0.value = Date(fromString: "\(glAgendaResp.endDate!) \(endTime)", format: .custom("YYYY-MM-dd HH:mm:ss"))
                } else {
                    $0.value = Date(timeIntervalSinceNow: 3600)
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                $0.dateFormatter = formatter
                }
            //            <<< LocationRow(){
            //                $0.title = "LocationRow"
            //                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
            //            }
            <<< PickerInputRow<String>("remind"){
                $0.title = "提醒"
                $0.options = GLRemindType.getTitleValues()
                if let typeIndex = glAgendaResp?.type {
                    $0.value = GLRemindType(rawValue: typeIndex)?.title
                } else {
                    $0.value = $0.options.first
                }
            }
            <<< PickerInputRow<String>("repeatType"){
                $0.title = "重复"
                $0.options = GLRepeatType.getTitleValues()
                if let typeIndex = glAgendaResp?.type {
                    $0.value = GLRepeatType(rawValue: typeIndex)?.title
                } else {
                    $0.value = $0.options.first
                }
            }
            <<< LabelRow() {
                $0.title = "摘要:"
                $0.value = ""
                }.cellSetup({ (cell, row) in
                    cell.spec
                })
            <<< TextAreaRow("digestContent") {
                $0.placeholder = "请输入你的摘要\n例如: 1.讨论产品设计风格\n2.确定产品风格"
                if let value = glAgendaResp?.digestContent {
                    $0.value = value
                }
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
            }
            tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func removeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        if let beginDate = form.values()["beginDate"] as? Date {
            glAgendaResp?.beginDate = beginDate.toString(format: .isoDate)
        }
        if
//        dismiss(animated: true, completion: nil)
    }
    
}
