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

    var leftViewController = LeftSideMenuViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftViewSwipeGestureEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadMenuView(initWithRootViewController: UIViewController, style: LGSideMenuPresentationStyle) {

        super.rootViewController = initWithRootViewController
        leftViewController = LeftSideMenuViewController.vc()
        self.setLeftViewEnabledWithWidth(250, presentationStyle: style, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions.OnNone)
        self.leftViewStatusBarStyle = UIStatusBarStyle.Default
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.OnNone
        self.leftViewBackgroundColor = Color.BackgroundSlideMenu
        leftViewController.view.backgroundColor = UIColor.clearColor()
        self.leftView().addSubview(leftViewController.view)

    }

    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        leftViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

}
