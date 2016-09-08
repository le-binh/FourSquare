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
import GoogleMaps
import FSOAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setup()
        cleanDatabase()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = self.rootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        self.handleUrl(url)
        return true
    }

    func rootViewController() -> UIViewController {
        let homeViewController = HomeViewController.vc()
        let navigationHomeController = UINavigationController(rootViewController: homeViewController)
        navigationHomeController.navigationBar.hidden = true
        let backgroundViewController = BackgroundViewController.sharedInstance
        backgroundViewController.loadMenuView(navigationHomeController, style: .SlideAbove)
        backgroundViewController.leftViewController.homeViewController = homeViewController
        return backgroundViewController
    }

    private func setup() {
        setupThirdParties()
    }

    private func setupThirdParties() {
        setupConsole()
        setupGoogleMapAPIKey()
    }

    private func setupConsole() {
//        XCConsole.enabled = true
//        #if DEBUG
//            XCConsole.enabled = true
//        #else
//            XCConsole.enabled = false
//        #endif
    }

    private func setupGoogleMapAPIKey() {
        GMSServices.provideAPIKey(GoogleMapsKeys.goolgeMapsApiKey)
    }

    private func cleanDatabase() {
        RealmManager.sharedInstance.deleteWithoutFavoriteAndHistory()
    }

    private func handleUrl(url: NSURL) {
        if url.scheme == APIKeys.urlScheme {
            var errorCode: FSOAuthErrorCode = .None
            let accessCode = FSOAuth.accessCodeForFSOAuthURL(url, error: &errorCode)
            if errorCode == .None {
                self.getAndSaveToken(accessCode)
            }
        }
    }

    private func getAndSaveToken(accessCode: String) {
        LoginService().getAndSaveToken(accessCode) { (completion) in
            if completion {
                let backgroundViewController = self.window?.rootViewController as? BackgroundViewController
                backgroundViewController?.reloadSideMenu()
            }
        }
    }

}
