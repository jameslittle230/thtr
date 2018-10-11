//
//  ReviewFeedController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReviewFeedController: UITableViewController {

    let cellReuseIdentifier = "reuseIdentifier"

    var reviews: [Review] = []

    lazy var profileButton = UIBarButtonItem(
        barButtonSystemItem: .bookmarks,
        target: self,
        action: #selector(displayAccountViewController(sender:))
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Feed"
        tableView.register(ReviewFeedCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none

        navigationItem.rightBarButtonItem = profileButton

        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            displayAccountViewController(sender: nil)
        }
    }

    // MARK: - Table View Data Source

    func loadData() {
        let dbRef = Database.database().reference(withPath: "reviews")
        dbRef.queryOrdered(byChild: "user")
            .queryEqual(toValue: Auth.auth().currentUser?.email ?? "")
            .observe(.value) { (multiSnapshot: DataSnapshot) -> Void in
                self.reviews = []

                for child in multiSnapshot.children {
                    guard let child = child as? DataSnapshot,
                        let review = Review(snapshot: child) else {
                            continue
                    }

                    self.reviews.append(review)
                }

                self.tableView.reloadData()
            }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? ReviewFeedCell else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            cell.configureAsNewReviewCell()
        default:
            cell.configureWithReview(reviews[indexPath.row - 1])
        }

        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackViewController = FeedbackViewController()
        navigationController?.pushViewController(feedbackViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    @objc
    func displayAccountViewController(sender: UIBarButtonItem?) {
        let accountVC = AccountViewController()
        let popoverRootVC = UINavigationController(rootViewController: accountVC)
        present(popoverRootVC, animated: true, completion: nil)
    }
}
