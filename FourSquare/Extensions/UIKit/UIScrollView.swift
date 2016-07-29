//
//  UIScrollView.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    var scrolledToEnd: Bool {
        let scrollViewHeight = bounds.height
        let contentOffsetY = contentOffset.y
        let contentSizeHeight = contentSize.height
        return contentSizeHeight - contentOffsetY < scrollViewHeight
    }
}
