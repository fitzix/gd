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

class AgendaDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
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
