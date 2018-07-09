//
//  FirstViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let date = Date(fromString: "2018-09-05", format: .isoDate)!
        let start = date.dateFor(.startOfMonth).component(.weekday)!
        let num = date.numberOfDaysInMonth()
       
        print(start, num,  (num + start - 1)/7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

