//
//  PerformanceSelectionControllerTableViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PerformanceSelectionController: UITableViewController {

    let cellReuseIdentifier = "reuseIdentifier"

    var shows: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        let dbRef = Database.database().reference()
        dbRef.observe(.value) { snapshot in
            guard let showsDictionary = snapshot.value as? NSDictionary else {
                return
            }

            self.shows = ((showsDictionary.allValues as? [String])?.sorted {
                return $0 > $1
            })!
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        return shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        cell.textLabel?.text = shows[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.productionViewModel = nil
        navigationController?.pushViewController(feedbackViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
