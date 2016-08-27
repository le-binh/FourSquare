//
//  TipsDetailVenueCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/6/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import Haneke
import SwiftUtils

class TipsDetailVenueCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var tipCommentLabel: UILabel!
    @IBOutlet weak var dateCommentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.configureUserAvatar()
    }

    private func configureUserAvatar() {
        let valueCorner = self.userAvatarImageView.frame.height / 2
        self.userAvatarImageView.cornerRadiusWith(valueCorner)
    }

    func setUpData(tip: VenueTip) {
        self.userAvatarImageView.image = UIImage(named: "image_loading")
        self.tipCommentLabel.text = tip.comment
        let date = NSDate(timeIntervalSince1970: tip.timeStamp)
        self.dateCommentLabel.text = date.toString(DateFormat.DateTime24NoSec, localized: true)
        guard let user = tip.userTip, avatar = user.avatar, url = avatar.avatarPath else {
            return
        }
        self.userAvatarImageView.hnk_setImageFromURL(url)

    }

}
