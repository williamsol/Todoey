//
//  AppDelegate.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // This function gets called when the app first launches
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // This function gets called when the app is terminated, either manually or by the system (because it needs to reallocate memory)
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // A "lazy" variable is assigned a value only when it is needed / when you try to use it
    // NSPersistentContainer is where we will store all our data; by default, it is a SQLite database
    lazy var persistentContainer: NSPersistentContainer = {
        
        // The name of our NSPersistentContainer must match that of our data model
        let container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // This function provides some support in saving our data when the app gets terminated
    func saveContext () {
        
        // Context is a temporary area where you can change and update your data before it is saved to the container
        // Context is similar to the "staging area" in Git and GitHub
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

