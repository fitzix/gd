//
//  MonthViewController.swift
//  gd
//
//  Created by fitz on 2018/7/4.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var calenderView: UIView!
    
    
    var startDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calView = GLCalender(frame: calenderView.bounds) { [weak self] (date) in
            self?.monthButton.setTitle(date.toString(format: .isoYearMonth), for: .normal)
        }
        calView.orientationCurrentDate(start: startDate)
        
        print("calView",calView.bounds)
        print("calenderView", calenderView.bounds)
        calenderView.addSubview(calView)

        calView.snp.makeConstraints { (constraintMaker) in
            constraintMaker.top.equalToSuperview()
            constraintMaker.left.equalToSuperview()
            constraintMaker.right.equalToSuperview()
            constraintMaker.bottom.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
