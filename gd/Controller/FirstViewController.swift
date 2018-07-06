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
        let a = calendar(2018, 10)
        let b = a?["monthData"] as? NSArray
        print(b?[1]["lunarDayName"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

