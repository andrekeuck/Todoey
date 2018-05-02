//
//  AppDelegate.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool { // very first thing to run in the app, even before the View Controller is loaded
        
        //print(Realm.Configuration.defaultConfiguration.fileURL) //print the filepath for the default.realm file
        
        do {
            _  = try Realm() //setup to output Realm function data
        } catch {
            print("Error with the Realm \(error)")
        }
        return true
    }
}

