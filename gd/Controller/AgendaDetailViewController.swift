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
    
    @IBOutlet weak var detailImg: UIImageView!
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    
    var glAgendaResp: GLAgendaResp? {
        didSet{
            print(glAgendaResp?.userList?[0].nickname)
//            if let icon = glAgendaResp?.userList?[0].icon {
//                print(icon)
//                detailImg.kf.setImage(with: URL(string: icon))
//            }
            createUserLabel.text = "\(glAgendaResp?.userList?[0].nickname ?? "--") 创建"
//            userCountLabel.text = "\(glAgendaResp?.userList?.count ?? 0)人参与"
//            eventTypeLabel.text = "\(glAgendaResp?.typeName ?? "日常")"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIImage()
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
