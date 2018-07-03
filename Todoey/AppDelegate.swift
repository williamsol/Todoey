//
//  AppDelegate.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // This function gets called when the app first launches
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // This function gets called e.g. when there is an incoming phone call
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    // This function gets called e.g. when the home button is pressed
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    // This function gets called when the app is terminated, either manually or by the system (because it needs to reallocate memory)
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }


}

