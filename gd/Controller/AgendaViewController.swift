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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section()
            <<< TextRow(){
                $0.placeholder = "请输入你的主题(限10个字) 例如: 周会"
            }
            +++ Section()
            <<< SegmentedRow<String>() {
                $0.title = "性质"
                $0.options = ["深度", "日常", "休闲"]
            }
            <<< DateTimeRow(){
                $0.title = "开始时间"
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd EE | HH:mm"
                $0.dateFormatter = formatter
            }
            <<< DateTimeRow(){
                $0.title = "结束时间"
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd EE | HH:mm"
                $0.dateFormatter = formatter
            }
            //            <<< LocationRow(){
            //                $0.title = "LocationRow"
            //                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
            //            }
            <<< PickerInputRow<String>("提醒"){
                $0.title = "提醒"
                $0.options = ["不提醒", "5分钟", "15分钟", "30分钟", "1小时", "1天前"]
                
                $0.value = $0.options.first
            }
            <<< PickerInputRow<String>("重复"){
                $0.title = "重复"
                $0.options = ["不重复", "每天", "每周", "每月", "每年"]
                
                $0.value = $0.options.first
            }
            <<< TextAreaRow() {
                $0.placeholder = "请输入你的摘要\n例如: 1.讨论产品设计风格\n2.确定产品风格"
                $0.value = "摘要:\n"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
        }
        tableView.tableFooterView = UIView()
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

    @IBAction func removeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
