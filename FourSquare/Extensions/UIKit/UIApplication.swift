//
//  UIApplication.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    func backgroundViewController() -> BackgroundViewController? {
        guard let delegate = self.delegate else {
            return nil
        }

        guard let rootViewController = delegate.window??.rootViewController else {
            return nil
        }

        return rootViewController as? BackgroundViewController
    }

    func navigationController() -> UINavigationController? {
        guard let navigationController = self.backgroundViewController()?.rootViewController as? UINavigationController else {
            return nil
        }
        return navigationController
    }

}
