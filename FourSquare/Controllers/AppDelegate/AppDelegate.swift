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
        self.createRootView()
        return true
    }

    func createRootView() {
        let homeViewController = HomeViewController.vc()
        let navigationHomeController = UINavigationController(rootViewController: homeViewController)
        navigationHomeController.navigationBar.hidden = true
        let backgroundViewController = BackgroundViewController()
        backgroundViewController.loadMenuView(navigationHomeController, style: .SlideAbove)
        window?.rootViewController = backgroundViewController
        window?.makeKeyAndVisible()
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
