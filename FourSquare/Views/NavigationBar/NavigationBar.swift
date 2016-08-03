//
//  NavigationBar.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import PureLayout

class NavigationBar: UIView {

    var titleLabel: UILabel!
    var leftButton: UIButton!
    var rightButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configView() {
        // Config Title Label
        self.titleLabel = UILabel(forAutoLayout: ())
        self.titleLabel.text = "Explore"
        self.addSubview(self.titleLabel)

        // Config Left Button
        self.leftButton = UIButton(forAutoLayout: ())
        self.leftButton.setImage(UIImage(named: "side_menu_ic"), forState: .Normal)
        self.addSubview(self.leftButton)

        // Config Right Button
        self.rightButton = UIButton(forAutoLayout: ())
        self.rightButton.setImage(UIImage(named: "list_map_ic"), forState: .Normal)
        self.addSubview(self.rightButton)

    }

}
