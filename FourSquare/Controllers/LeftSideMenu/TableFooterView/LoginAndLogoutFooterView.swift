//
//  LoginAndLogoutFooterView.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/27/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

protocol LoginAndLogoutDelegate {
    func loginOrLogoutAction(title: String)
}

class LoginAndLogoutFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var footerTitleLabel: UILabel!
    var delegate: LoginAndLogoutDelegate!

    @IBAction func loginOrLogoutAction(sender: AnyObject) {
        if let title = self.footerTitleLabel.text {
            delegate?.loginOrLogoutAction(title)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
