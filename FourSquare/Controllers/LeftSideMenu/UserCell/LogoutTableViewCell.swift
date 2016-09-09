//
//  LoginTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

protocol LogoutCellDelegate: NSObjectProtocol {
    func logoutAction()
}

class LogoutTableViewCell: UITableViewCell {

    @IBOutlet private(set) weak var userAvatarImageView: UIImageView!
    @IBOutlet private(set) weak var userNameLabel: UILabel!
    weak var delegate: LogoutCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.configureData()

    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        userAvatarImageView.cornerRadiusWith(userAvatarImageView.frame.height / 2)
    }

    private func configureData() {
        guard let user = UserRealmManager.sharedInstance.getUser() else {
            return
        }
        self.userNameLabel.text = user.getFullName()
        if let url = user.avatar?.userAvatarPath {
            self.userAvatarImageView.hnk_setImageFromURL(url)
        }
    }

    @IBAction func logoutAction(sender: AnyObject) {
        delegate?.logoutAction()
    }

}
