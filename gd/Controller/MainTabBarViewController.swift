//
//  MainTabBarViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/21.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 2 {
            let x = self.storyboard?.instantiateViewController(withIdentifier: "AgendaViewController") as! AgendaViewController
            present(x, animated: true, completion: nil)
            return false
        }
        return true
    }
}
