//
//  ShowSelectionViewController.swift
//  feedback
//
//  Created by James Little on 2/25/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit
import Firebase

class ShowSelectionViewController: UITableViewController {
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

                // @TODO Use firebase query here instead of appending each one :/
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
        return ShowSelectionViewController.Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.get(section) {
        case .serverSideShows:
            return shows.count
        case .createYourOwn:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        switch Section.get(indexPath.section) {
        case .serverSideShows:
            cell.textLabel?.text = shows[indexPath.row].title

            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
            cell.addGestureRecognizer(longPressGesture)
        case .createYourOwn:
            cell.textLabel?.text = "Add your own"
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section.get(indexPath.section) {
        case .serverSideShows:
            guard let showKey = shows[indexPath.row].key else {
                return
            }

            GlobalReviewCoordinator.getCurrentReview()?.show = showKey
            navigationController?.pushViewController(ReviewEditViewController(), animated: true)
        case .createYourOwn:
            navigationController?.pushViewController(ShowCreationViewController(), animated: true)
        }
    }

    @objc
    func didLongPressCell(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let actionSheet = UIAlertController(
                title: (sender as? UITableViewCell)?.textLabel?.text,
                message: nil,
                preferredStyle: .actionSheet)

            actionSheet.addAction(UIAlertAction(title: "Edit Show", style: .default) { _ in return })
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in return })

            present(actionSheet, animated: true)
        }
    }
}
