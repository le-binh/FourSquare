//
//  AppDelegate.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import XCConsole

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setup()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = LoginViewController.vc()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setup() {
        setupThirdParties()
    }
    
    private func setupThirdParties() {
        setupConsole()
    }
    
    private func setupConsole() {
        #if DEBUG
            XCConsole.enabled = true
        #else
            XCConsole.enabled = false
        #endif
    }
}
