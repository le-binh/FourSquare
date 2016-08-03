//
//  BackgroundViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import LGSideMenuController

class BackgroundViewController: LGSideMenuController {

    // MARK:- Singleton

    class var sharedInstance: BackgroundViewController {
        struct Static {
            static let instance: BackgroundViewController = BackgroundViewController()
        }
        return Static.instance
    }

    // MARK:- Properties

    var leftViewController = LeftSideMenuViewController()

    var allMenuItems = [ItemMenu]()

    var activeMenuItems = [ItemMenu]()

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftViewSwipeGestureEnabled = false
        for i in 0..<6 {
            let item = ItemMenu(item: MenuItemsSlide(rawValue: i)!, active: false)
            allMenuItems.append(item)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateItem), name: "ChangeItem", object: nil)
    }

    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        leftViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    // MARK:- Public Function

    func loadMenuView(initWithRootViewController: UIViewController, style: LGSideMenuPresentationStyle) {

        super.rootViewController = initWithRootViewController
        leftViewController = LeftSideMenuViewController.vc()
        self.setLeftViewEnabledWithWidth(UIScreen.mainScreen().bounds.width * (2 / 3), presentationStyle: style, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions.OnNone)
        self.leftViewStatusBarStyle = UIStatusBarStyle.Default
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.OnNone
        self.leftViewBackgroundColor = Color.BackgroundSlideMenu
        leftViewController.view.backgroundColor = UIColor.clearColor()
        self.leftView().addSubview(leftViewController.view)

    }

    func updateItem(notification: NSNotification) {
        if let infoUser = notification.userInfo {
            if let item = infoUser["item"] as? ItemMenu {
                self.allMenuItems[item.item.rawValue] = item
            }
        }

        self.activeMenuItems = self.allMenuItems.filter({
            $0.active == true
        })

    }

}
