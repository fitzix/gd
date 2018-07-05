//
//  MonthViewController.swift
//  gd
//
//  Created by fitz on 2018/7/4.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var slackView: UIStackView!
    @IBOutlet weak var monthButton: UIButton!
    
    
    var startDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let calHeight = view.bounds.height - (statusBarHeight + tabBarHeight!) - (25 + 44)
        
        let calender = GLCalender(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: calHeight )) { (date) in
            self.monthButton.setTitle(date.toString(format: .isoYearMonth), for: .normal)
        }
        calender.orientationCurrentDate(start: startDate)
        tabBarController?.tabBar.backgroundColor = .white
        
        view.addSubview(calender)
        
        calender.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalTo(slackView.snp.bottom)
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func buttonShow(_ sender: UIButton) {
        
    }
}
