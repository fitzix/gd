//
//  MainTabBarViewController.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/21.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import KRProgressHUD

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        KRProgressHUD.appearance().style = .black
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotify(notification:)), name: .GLDidReceiveEvent, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let addAgendaNavVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAgendaNavVC") as! UINavigationController
            present(addAgendaNavVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @objc func receiveNotify(notification: Notification) {
        
        guard let idStr = notification.userInfo?["id"] as? String, let eventId = Int(idStr) else {
            return
        }
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "AgendaDetailViewController") as! AgendaDetailViewController
        detailVC.glAgendaResp.id = Int(eventId)
        detailVC.fromTableView = false
        present(detailVC, animated: true, completion: nil)
    }
}
