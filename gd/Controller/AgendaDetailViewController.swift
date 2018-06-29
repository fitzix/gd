//
//  AgendaDetailViewController.swift
//  gd
//
//  Created by fitz on 2018/6/29.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Kingfisher
import Eureka

class AgendaDetailViewController: FormViewController {
    
    var glAgendaResp: GLAgendaResp?
    
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        LabelRow.defaultCellUpdate = { cell, row in cell.textLabel?.textColor = .gray }
        
        form
            +++ Section()
            <<< LabelRow () {
                $0.title = "主题"
                $0.value = glAgendaResp?.title
            }
            <<< LabelRow () {
                $0.title = "开始时间"
                let date = Date(fromString: "\(glAgendaResp!.beginDate!) \(glAgendaResp!.beginTime!)", format: .custom("YYYY-MM-dd HH:mm:ss"))
                $0.value = date?.toString(format: .custom("YYYY-MM-dd EE | HH:mm"))
            }
            <<< LabelRow () {
                $0.title = "结束时间"
                let date = Date(fromString: "\(glAgendaResp!.endDate!) \(glAgendaResp!.endTime!)", format: .custom("YYYY-MM-dd HH:mm:ss"))
                $0.value = date?.toString(format: .custom("YYYY-MM-dd EE | HH:mm"))
            }
            <<< LabelRow () {
                $0.title = "提醒"
                $0.value = glAgendaResp?.remind
            }
            
            <<< PushRow<String>() {
                $0.title = "可选时间段"
                $0.options = ["a", "b", "c", "d"]
                $0.value = "a"
                $0.selectorTitle = "Choose an Emoji!"
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            
            +++ Section()
            <<< LabelRow () {
                $0.title = "摘要"
                $0.value = ""
            }
            <<< TextAreaRow() {
                $0.value = glAgendaResp?.digestContent
                $0.disabled = true
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red:0.01, green:0.48, blue:1.00, alpha:1.00)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(red:0.01, green:0.48, blue:1.00, alpha:1.00)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func loadData() {
        if let icon = glAgendaResp?.userList?[0].icon {
            detailImg.kf.setImage(with: URL(string: icon))
        }
        createUserLabel.text = "\(glAgendaResp?.userList?[0].nickname ?? "--") 创建"
        userCountLabel.text = "\(glAgendaResp?.userList?.count ?? 0)人参与"
        eventTypeLabel.text = "\(glAgendaResp?.typeName ?? "日常")"
    }
}
