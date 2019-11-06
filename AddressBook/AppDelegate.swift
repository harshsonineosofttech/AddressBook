//
//  AppDelegate.swift
//  AddressBook
//
//  Created by Pratik Hirve on 05/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        print("Realm Path: - \(Realm.Configuration.defaultConfiguration.fileURL!)")
        return true
    }

}

