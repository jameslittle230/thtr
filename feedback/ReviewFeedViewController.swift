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

class ReviewFeedViewController: UITableViewController {

    enum Section: CaseIterable {
        case create
        case reviews

        static var count: Int {
            return self.allCases.count
        }

        static func get(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }

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

        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: ShowCollector.updateNotification, object: nil)
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

        if GlobalReviewCoordinator.getCurrentReview() != nil {
            GlobalReviewCoordinator.unsetCurrentReview()
        }
    }

    // MARK: - Table View Data Source

    @objc
    func loadData() {
        let dbRef = Database.database().reference(withPath: "reviews")
        dbRef.queryOrdered(byChild: "updated")
            .observe(.value) { (multiSnapshot: DataSnapshot) -> Void in
                self.reviews = []

                for child in multiSnapshot.children {
                    guard let child = child as? DataSnapshot,
                        let review = Review(snapshot: child) else {
                            continue
                    }

                    // client-side auth filtering...
                    if review.dict["user"] as? String == Auth.auth().currentUser?.email {
                        self.reviews.append(review)
                    }
                }

                // This is also bad.
                self.reviews.reverse()

                self.tableView.reloadData()
            }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.get(section) {
        case .create:
            return 1
        case .reviews:
            return reviews.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? ReviewFeedCell else {
            return UITableViewCell()
        }

        switch Section.get(indexPath.section) {
        case .create:
            cell.configureAsNewReviewCell()
        case .reviews:
            cell.configureWithReview(reviews[indexPath.row])

            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
            cell.addGestureRecognizer(longPressGesture)
        }

        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section.get(indexPath.section) {
        case .create:
            GlobalReviewCoordinator.createNew()
            navigationController?.pushViewController(ShowSelectionViewController(), animated: true)
        case .reviews:
            GlobalReviewCoordinator.setReview(reviews[indexPath.row])
            navigationController?.pushViewController(ReviewEditViewController(), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    @objc
    func displayAccountViewController(sender: UIBarButtonItem?) {
        let popoverRootVC = UINavigationController(rootViewController: AccountViewController())
        present(popoverRootVC, animated: true, completion: nil)
    }

    @objc
    func didLongPressCell(_ sender: UIGestureRecognizer) {
        guard let cell = sender.view as? ReviewFeedCell else {
            return
        }

        if sender.state == .began {
            guard cell.contentType == .existingReview, let review = cell.review else {
                return
            }

            let actionSheet = UIAlertController(
                title: review.reviewText?.truncate(length: 80),
                message: nil,
                preferredStyle: .actionSheet)

            actionSheet.addAction(UIAlertAction(title: "Delete Review", style: .destructive) { _ in
                review.delete()
            })

            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in return })

            present(actionSheet, animated: true)
        }
    }
}
