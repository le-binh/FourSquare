//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class MenuItemViewController: ViewController {

    // MARK:- Outlet

    @IBOutlet weak var venueTableView: UITableView!

    // MARK:- Properties

    var defaultItem: DefaultMenuItem?
    var menuItem: MenuItemsSlide?

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
        self.venueTableView.registerNib(VenueItemTableViewCell)
        self.venueTableView.delegate = self
        self.venueTableView.dataSource = self
    }
}

//MARK:- Table View Delegate

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
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Table View Datasource

extension MenuItemViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
}
