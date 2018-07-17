//
//  AppDelegate.swift
//  gd
//
//  Created by Fitz Leo on 2018/6/20.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import UIKit
import MonkeyKing
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 获取日历事件权限
        EventKitUtil.shared.getEvent()
        // 注册微信
        MonkeyKing.registerAccount(.weChat(appID: "wxe72e6e1d86a08401", appKey: nil, miniAppID: nil))
        // 判断登录
        Switcher.updateRootVC()
        // 注册小米推送
        MiPushSDK.registerMiPush(self)
        // 获取通知权限
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    print("用户不允许消息通知。")
                }
            }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            if let info = launchOptions?[.remoteNotification], let userInfo = info as? [AnyHashable : Any] {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak self] in
                    self?.postAgendaEvent(info: userInfo)
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MiPushSDKDelegate {
    // 像小米发送token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MiPushSDK.bindDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if UIApplication.shared.applicationState == .active {
            let alertController = UIAlertController(title: "提醒", message: "你确定要离开？", preferredStyle:.alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default) { _ in
                LocalStore.logout()
            }
            // 添加
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
        } else {
           postAgendaEvent(info: userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // 点击通知进入应用
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.trigger is UNPushNotificationTrigger {
            postAgendaEvent(info: response.notification.request.content.userInfo)
        }
        completionHandler()
    }
    
    func postAgendaEvent(info: [AnyHashable : Any]) {
        NotificationCenter.default.post(name: .GLDidReceiveEvent, object: nil, userInfo: info)
    }
}

