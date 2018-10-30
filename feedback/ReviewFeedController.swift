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
        image: UIImage(named: "account"),
        style: .plain,
        target: self,
        action: #selector(displayAccountViewController(sender:))
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review Feed"
        tableView.register(ReviewFeedCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none

        navigationItem.rightBarButtonItem = profileButton
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            self.reviews = []
            tableView.reloadData()
            displayAccountViewController(sender: nil)
        } else {
            loadData()
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return reviews.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? ReviewFeedCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case 0:
            cell.configureAsNewReviewCell()
        default:
            cell.configureWithReview(reviews[indexPath.row])
        }

        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section != 0 {
            let feedbackViewController = FeedbackViewController()
            feedbackViewController.model = reviews[indexPath.row]
            navigationController?.pushViewController(feedbackViewController, animated: true)
        } else {
            let showPickingViewController = ShowPickingViewController()
            navigationController?.pushViewController(showPickingViewController, animated: true)
        }
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
