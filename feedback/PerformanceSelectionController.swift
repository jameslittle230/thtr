//
//  PerformanceSelectionControllerTableViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class PerformanceSelectionController: UITableViewController {
    
    let cellReuseIdentifier = "reuseIdentifier"
    
    let musicals = [
        "Hairspray",
        "Jersey Boys",
        "Spamalot",
        "The Book of Mormon",
        "Hamilton"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shows"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = musicals[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}
