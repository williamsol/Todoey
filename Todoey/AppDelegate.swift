//
//  AppDelegate.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // This function gets called when the app first launches
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Uncomment this line in order to print the Realm file location to the debug area upon launching of the app
         print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Try creating a new realm (persistent storage/container) here, just to see if there are any errors; this realm is not actually used
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

}

