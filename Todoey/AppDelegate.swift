//
//  AppDelegate.swift
//  CoreDataCRUD
//
//  Created by Ankur on 7/4/18.
//  Copyright © 2018 ankur. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
         
            let realm = try! Realm()
//                try! realm.write {
//                  realm.deleteAll()
//                }
            
        } catch {
            print("Error while initializing Realm: \(error)")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
}



























