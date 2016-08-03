//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {

    @IBOutlet weak var venueTableView: UITableView!

    // MARK:- Properties

    var defaultItem: DefaultMenuItem?
    var menuItem: MenuItemsSlide?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }

    // MARK:- Private Function

    private func setUpTableView() {
        self.venueTableView.registerNib(VenueTableViewCell)
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
        let cell = tableView.dequeue(VenueTableViewCell)
        return cell
    }
}

//MARK:- Table View Datasource

extension MenuItemViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 141
    }
}
