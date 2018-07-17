//
//  Switcher.swift
//  gd
//
//  Created by fitz on 2018/7/10.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit

class Switcher {
    class func updateRootVC() {
        var rootVC: UIViewController?
        
        if LocalStore.isLogin {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
}
