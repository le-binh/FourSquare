//
//  ViewForHeaderMenuItems.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class ViewForHeaderMenuItems: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleMenu: UILabel!

    func setTitleMenuText(text: String) {
        self.titleMenu.text = text
    }
}
