//
//  NavigationBar.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class NavigationBar: UIView {

    // MARK:- Properties

    // var barHeight: CGFloat = 64
    var barButtonPadding: CGFloat = 20
    private var titleLabel: UILabel!
    private let titleViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    var leftBarButton: UIButton? {
        willSet {
            leftBarButton?.removeFromSuperview()
        }

        didSet {
            if let button = leftBarButton {
                addSubview(button)
            }
        }
    }
    var rightBarButton: UIButton? {
        willSet {
            rightBarButton?.removeFromSuperview()
        }

        didSet {
            if let button = rightBarButton {
                addSubview(button)
            }
        }
    }
    var titleView: UIView? {
        willSet {
            titleView?.removeFromSuperview()
        }

        didSet {
            if let view = titleView {
                addSubview(view)
            }
            titleLabel.hidden = titleView != nil
        }
    }
    var title: String? {
        didSet {
            titleLabel.attributedText = NSAttributedString(string: title ?? "", attributes: UINavigationBar.appearance().titleTextAttributes)
        }
    }

    var rightBarButtonHidden: Bool = false {
        didSet {
            rightBarButton?.hidden = rightBarButtonHidden
        }
    }

    // MARK:- LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let leftBarButtonWidth = barButtonWidth(leftBarButton, padding: barButtonPadding)
        let rightBarButtonWidth = barButtonWidth(rightBarButton, padding: barButtonPadding)
        leftBarButton?.frame = CGRect(x: 0, y: 0, width: leftBarButtonWidth, height: bounds.height)
        rightBarButton?.frame = CGRect(x: bounds.width - rightBarButtonWidth, y: 0, width: rightBarButtonWidth, height: bounds.height)
        let titleViewWidth = bounds.width - (leftBarButtonWidth + rightBarButtonWidth) - (titleViewInsets.left + titleViewInsets.right)
        let titleViewHeight = bounds.height - (titleViewInsets.top + titleViewInsets.bottom)
        titleLabel.frame = CGRect(x: leftBarButtonWidth, y: titleViewInsets.top, width: titleViewWidth, height: titleViewHeight)
        titleView?.frame = titleLabel.frame
    }

    // MARK:- Private functions

    private func commonInit() {
        configureSubviews()
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: kScreenSize.width, height: 1))
        lineView.backgroundColor = UIColor.grayColor()
        addSubview(lineView)
    }

    private func configureSubviews() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
    }

    private func barButtonWidth(button: UIButton?, padding: CGFloat) -> CGFloat {
        let buttonSize = leftBarButton?.imageView?.image?.size ?? CGSize(width: 0, height: 0)
        let buttonSizeWidth = buttonSize.width + 2 * barButtonPadding
        return buttonSizeWidth
    }
}
