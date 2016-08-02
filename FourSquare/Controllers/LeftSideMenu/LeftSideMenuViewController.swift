//
//  LeftSideMenuViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMenuTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpMenuTableView() {
        self.menuTableView.registerNib(UINib(nibName: "CustomMainMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "mainMenuCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }

}

extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 6
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        return 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    }
}
