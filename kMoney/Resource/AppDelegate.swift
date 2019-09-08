//
//  AppDelegate.swift
//  kMoney
//
//  Created by ohlulu on 2019/4/14.
//  Copyright © 2019 ohlulu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        printDebug(documentsPath)
        
        initialUserDefault()
        
        initialWindow()
        
        RealmHelper.migration()
        
        RealmHelper.initial()
        
        ModelUtility.initModel()
        
        return true
    }
}

// MARK: Initail func

extension AppDelegate {
    
    func initialWindow() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabbar = DashboardTabBarController()
        
        window!.rootViewController = tabbar
        window!.makeKeyAndVisible()
    }
    
    func initialUserDefault() {
        let defaults = [
            "oprne": false
        ]
        
        UserDefaults.standard.register(defaults: defaults)
    }
}

