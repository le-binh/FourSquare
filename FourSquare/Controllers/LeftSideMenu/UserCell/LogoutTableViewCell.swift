//
//  LoginTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

protocol LogoutCellDelegate {
    func logoutAction()
}

class LogoutTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var delegate: LogoutCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.configureData()
    }

    private func configureData() {
        guard let user = UserRealmManager.sharedInstance.getUser() else {
            return
        }
        self.userNameLabel.text = user.getFullName()
        if let url = user.avatar?.userAvatarPath {
            self.userAvatarImageView.hnk_setImageFromURL(url)
            self.userAvatarImageView.cornerRadiusWith(self.userAvatarImageView.frame.height / 2)
        }
    }
    @IBAction func logoutAction(sender: AnyObject) {
        delegate?.logoutAction()
    }

}
