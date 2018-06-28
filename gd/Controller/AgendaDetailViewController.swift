//
//  AgendaDetailViewController.swift
//  gd
//
//  Created by fitz on 2018/6/27.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import Eureka
import Kingfisher

class AgendaDetailViewController: FormViewController {
    
    var glAgendaData: GLAgendaResp?
    var isRowEdit = false

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.topItem?.title = glAgendaData?.title
        
        // form
        form
            +++ Section() { section in
                section.header = {
                    return HeaderFooterView<UIView>(.callback({
                        let view = UINib(nibName: "GLAgendaDetailHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as! GLAgendaDetailHeader
                        view.loadData(glAgendaData: self.glAgendaData)
                        return view
                    }))
                }()
            }
            +++ Section()
            
            <<< TextRow(){
                $0.title = "主题"
                $0.placeholder = "请输入你的主题(限10个字) 例如: 周会"
                $0.disabled = true
            }
            <<< DateTimeRow(){
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd EE | HH:mm"
                $0.dateFormatter = formatter
                $0.disabled = true
            }
            .cellSetup { cell, row in
                cell.imageView?.image = #imageLiteral(resourceName: "icon_edit")
            }
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

// 事件详情头部视图

class GLAgendaDetailHeader: UIView {
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(glAgendaData: GLAgendaResp?) {
        if let icon = glAgendaData?.userList?[0].icon {
            detailImg.kf.setImage(with: URL(string: icon))
        }
        createUserLabel.text = "\(glAgendaData?.userList?[0].nickname ?? "--")  创建"
        userCountLabel.text = "\(glAgendaData?.userList?.count ?? 0)人参与"
        eventTypeLabel.text = "\(glAgendaData?.typeName ?? "日常")"
    }
}
