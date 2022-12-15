//
//  AppDelegate.swift
//  Dingweibao
//
//  Created by LiQi on 2020/5/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Application.shared.configureDependencies()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white

        let libsManager = LibsManager.shared
        libsManager.setupLibs(with: window, launchOptions: launchOptions)
        libsManager.isStartApp = true
        
        Application.shared.configureMainInterface(in: window)
        self.window = window
        self.window?.makeKeyAndVisible()
        
        let _ = CheckManager.shared
        
        let userManager = UserManager.shared
        userManager.updateUser()
        
        let payManager = PayManager.shared
        payManager.completeTransactionsWhenAppStart()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let umResult = LibsManager.shared.handleUM(open: url, options: options)
        return umResult
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("deviceToken: \(deviceTokenStr)")
        LibsManager.shared.deviceToken = deviceTokenStr
        if UserManager.shared.isLogin {
            NetManager.requestResponse(.updateDeviceToken(token: deviceTokenStr)).subscribe(onSuccess: { _ in
                print("success to regist deviceToken: \(deviceTokenStr)")
            }).disposed(by: rx.disposeBag)
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LibsManager.shared.isStartApp = false
    }


}

