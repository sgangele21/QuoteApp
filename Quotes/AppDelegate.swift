//
//  AppDelegate.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/11/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

/*
 Great explanation on stack overflow for the purpose of cocoapods: 
 "CocoaPods is the dependency manager for Objective-C projects. It has thousands of libraries and can help you scale your projects elegantly." via http://cocoapods.org
 
 Essentially, it helps you incorporate 3rd party libraries, frameworks, into your product without worrying about how to set them up and configure your project, which at times could be a huge pain.
 
 Regarding why can't you just include files in your project?
 
 Since these are 3rd party so you will have to download and copy them to your project every time there is a new version? Lets say, you have 10 libs or frameworks in your project, now imagine the time it will take you to check if anyone of them has any new version that you want to update? and Worst if something does not work, you need to revert back to previous version? It does take time and is a nuisance, with CocoaPods you simply type pod update and updates the ones that have newer versions available.
 Now If you want v1.1 of one particular library? How easy would it be for you to skim through Git commit history to find out which one you need? With CocoaPods, you simply say pod 'AFrameworkLib', '1.1'
 Every lib requires setting up your project with a certain set of configuration to make them work, doing it for 10 or so libraries and then fixing conflicts is pain in itself. With CocoaPods, its taken care of automatically.
 Last but not least, you have to include licenses for all 3rd party libraries you are using to provide credit to original developer of that library. Imagine copying 10 license docs and making sure they are up to date? CocoaPod automatically creates an acknowledgement file in your project that you can simply include somewhere appropriate.
 */

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        FIRApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Quotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

