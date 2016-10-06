//
//  ViewHeaderVenueDetail.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/6/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class ViewHeaderVenueDetail: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleHeader: UILabel!

    func setTitleHeaderText(text: String) {
        self.titleHeader.text = text
    }

}
