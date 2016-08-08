//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class MenuItemViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var venueTableView: UITableView?
    let rowHeight: CGFloat = 140

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    // MARK:- Private Function

    private func setUpTableView() {
        self.venueTableView?.backgroundColor = Color.Caramel255
        self.venueTableView?.separatorStyle = .None
        self.venueTableView?.registerNib(VenueItemTableViewCell)
        self.venueTableView?.dataSource = self
        self.venueTableView?.rowHeight = self.rowHeight
    }
}

//MARK:- Table View Datasource

extension MenuItemViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(VenueItemTableViewCell)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVenueViewController = DetailVenueViewController.vc()
        detailVenueViewController.title = "Phố xưa"
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MenuItemViewController {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {

    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

    }

}
