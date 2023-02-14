//
//  LibsManager.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reusable
import IQKeyboardManagerSwift
//import FLEX
import AMapFoundationKit
import Hue


class LibsManager: NSObject {
    
    static let shared = LibsManager()
    
    private var launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    var isStartApp = false
    
    var deviceToken = ""
    
    func setupLibs(with window: UIWindow? = nil, launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        self.launchOptions = launchOptions
//        let libsManager = LibsManager.shared
//        libsManager.setupCocoaLumberjack()
//        libsManager.setupAnalytics()
//        libsManager.setupAds()
//        libsManager.setupTheme()
//        libsManager.setupFLEX()
        setupKeyboardManager(enable: true)
        setupUM()
//        setupFLEX()
        setupMap()
//        libsManager.setupActivityView()
//        libsManager.setupDropDown()
//        libsManager.setupToast()
        
    }
    
    func setupKeyboardManager(enable: Bool) {
        IQKeyboardManager.shared.enable = enable
    }
    
    func setupKeyboardManagerShow(show: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = show
    }
    
//    func setupFLEX() {
//        FLEXManager.shared.isNetworkDebuggingEnabled = true
//        FLEXManager.shared.showExplorer()
//    }
    
    // MARK: - 地图
    
    func setupMap() {
        AMapServices.shared()?.apiKey = "xxxx"
        AMapServices.shared()?.enableHTTPS = true
    }
    
    // MARK: - UM
    
    func setupUM(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        
        UMCommonLogManager.setUp()
        UMConfigure.setLogEnabled(false)
        UMConfigure.initWithAppkey("xxx", channel: "App Store")

        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "xxx", appSecret: "xxx", redirectURL: "http://mobile.umeng.com/social")
        
        MobClick.setCrashReportEnabled(true)
        
        
    }
    
    func registerUMPush() {
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue|UMessageAuthorizationOptions.sound.rawValue|UMessageAuthorizationOptions.alert.rawValue)
        UNUserNotificationCenter.current().delegate = self
        UMessage.setBadgeClear(true)
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted {
                print("注册通知成功")
            } else {
                print("注册通知失败: %@", error as Any)
            }
        }
    }

    func handleUM(open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if let manager = UMSocialManager.default() {
            return manager.handleOpen(url, options: options)
        }
        return false
    }
    
}

extension LibsManager: UNUserNotificationCenterDelegate {
    
    //iOS10新增：处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            let info = userInfo as NSDictionary
            print(info)
            //应用处于前台时的远程推送接受
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
            PushManager.shared.addPushInfo.accept(notification.request.content)
            
        }else {
            //应用处于前台时的远程推送接受
        }
        completionHandler([.sound])
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            let info = userInfo as NSDictionary
            print(info)
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
//            if !isStartApp {
                PushManager.shared.addPushInfo.accept(response.notification.request.content)
//            }
        }else{
            //应用处于前台时的远程推送接受
        }
        completionHandler()
        isStartApp = false
    }
    
}


