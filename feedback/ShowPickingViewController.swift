//
//  ShowPickingViewController.swift
//  feedback
//
//  Created by James Little on 10/23/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase

class ShowPickingViewController: UITableViewController {

    enum Section: CaseIterable {
        case serverSideShows
        case createYourOwn

        static var count: Int {
            return self.allCases.count
        }

        static func get(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }

    let cellReuseIdentifier = "reuseIdentifier"

    var shows: [Show] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    func loadData() {
        let dbRef = Database.database().reference().child("rich_shows")
        dbRef.queryOrderedByKey().observe(.value) { (multiSnapshot: DataSnapshot) -> Void in
            self.shows = []

            for child in multiSnapshot.children {
                guard let child = child as? DataSnapshot,
                    let show = Show(snapshot: child) else {
                        continue
                }

                self.shows.append(show)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shows"
        tableView.register(THTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(popThroughToGoBack))
        loadData()
    }

    @objc
    func popThroughToGoBack(button: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShowPickingViewController.Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < 2 ? shows.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        switch Section.get(indexPath.section) {
        case .serverSideShows:
            cell.textLabel?.text = shows[indexPath.row].name
//            cell.detailTextLabel?.text = shows[indexPath.row].theater
        case .createYourOwn:
            cell.textLabel?.text = "Add your own"
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.get(indexPath.section) {
        case .serverSideShows:
            let feedbackViewController = FeedbackViewController()
            feedbackViewController.reviewedShow = shows[indexPath.row].key
            navigationController?.pushViewController(feedbackViewController, animated: true)
        case .createYourOwn:
            let showCreationViewController = ShowCreationViewController()
            navigationController?.pushViewController(showCreationViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
