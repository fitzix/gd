//
//  MonthViewController.swift
//  gd
//
//  Created by fitz on 2018/7/4.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import KRProgressHUD

class MonthViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var slackView: UIStackView!
    @IBOutlet weak var monthButton: UIButton!
    
    var calenderView: GLCalender?
    
    
    var startDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let calHeight = view.bounds.height - (statusBarHeight + tabBarHeight!) - (25 + 44)
        GLAgendaDataUtil.shared.taskListDidSelect = { [weak self] id, begin, end in
            let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
            detailVC.glAgendaResp.id = id
            detailVC.glAgendaResp.beginDate = begin
            detailVC.glAgendaResp.endDate = end
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
       
        calenderView = GLCalender(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: calHeight )) { (date) in
            if date.compare(.isEarlier(than: GLAgendaDataUtil.shared.startDate)) {
                GLAgendaDataUtil.shared.loadData(after: false)
            } else if date.compare(.isLater(than: GLAgendaDataUtil.shared.endDate)) {
                GLAgendaDataUtil.shared.loadData()
            }
            self.monthButton.setTitle(date.toString(format: .isoYearMonth), for: .normal)
        }
        calenderView?.orientationCurrentDate(start: startDate)
        tabBarController?.tabBar.backgroundColor = .white
        
        view.addSubview(calenderView!)
        
        calenderView?.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalTo(slackView.snp.bottom)
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        if GLAgendaDataUtil.shared.needRefresh {
            KRProgressHUD.show()
            GLAgendaDataUtil.shared.needRefresh = false
            GLAgendaDataUtil.shared.loadData(after: false) { [weak self] succeed in
                KRProgressHUD.dismiss()
                if succeed {
                    self?.calenderView?.reloadData()
                    GLAgendaDataUtil.shared.hasNewData = true
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func viewBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
