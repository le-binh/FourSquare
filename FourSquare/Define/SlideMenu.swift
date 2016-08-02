//
//  ChangeRootSlideMenu.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class SlideMenu {
    static let getRootBackground = (UIApplication.sharedApplication().delegate?.window!!.rootViewController as? BackgroundViewController)!
    static let getRootViewController = (SlideMenu.getRootBackground.rootViewController as? UINavigationController)!

}
