//
//  FeedbackViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackViewController: UITableViewController {

    let feedbackSliderCellReuseID = "feedbackSliderTableViewCellReuseIdentifier"
    let feedbackCommentsCellReuseID = "feedbackCommentsTableViewCellReuseIdentifier"

    var productionViewModel: String?
    var feedbackViewModel: (sliderValues: [FeedbackItemViewModel], comment: String) = ([
        FeedbackItemViewModel(type: .timeDistortion, value: 0),
        FeedbackItemViewModel(type: .spaceDistortion, value: 0),
        FeedbackItemViewModel(type: .bodyDistortion, value: 0)
    ], "")

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = "Give Feedback"

        tableView.register(FeedbackSliderTableViewCell.self, forCellReuseIdentifier: feedbackSliderCellReuseID)
        tableView.register(FeedbackCommentsTableViewCell.self, forCellReuseIdentifier: feedbackCommentsCellReuseID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < feedbackViewModel.sliderValues.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackSliderCellReuseID) as? FeedbackSliderTableViewCell else {
                fatalError()
            }

            cell.model = feedbackViewModel.sliderValues[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackCommentsCellReuseID) as? FeedbackCommentsTableViewCell else {
                fatalError()
            }

            cell.model = feedbackViewModel.comment
            return cell
        }
    }
}
