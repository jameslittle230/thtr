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
    let feedbackSubmitCellReuseID = "feedbackSubmitTableViewCellReuseIdentifier"

    let displayedCells: [FeedbackTableViewCellType] = [
        .slider(type: .timeDistortion),
        .slider(type: .spaceDistortion),
        .slider(type: .bodyDistortion),
        .comments,
        .submit
    ]

    var show: String? {
        didSet {
            feedbackViewModel.show = show ?? ""
        }
    }

    var feedbackViewModel = FeedbackViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = "Give Feedback"

        tableView.keyboardDismissMode = .onDrag

        tableView.register(FeedbackSliderTableViewCell.self, forCellReuseIdentifier: feedbackSliderCellReuseID)
        tableView.register(FeedbackCommentsTableViewCell.self, forCellReuseIdentifier: feedbackCommentsCellReuseID)
        tableView.register(FeedbackSubmitTableViewCell.self, forCellReuseIdentifier: feedbackSubmitCellReuseID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        switch displayedCells[indexPath.row] {
        case let .slider(distortionType):
            let sliderCell = tableView.dequeueReusableCell(withIdentifier: feedbackSliderCellReuseID) as? FeedbackSliderTableViewCell
            sliderCell?.type = distortionType
            sliderCell?.model = feedbackViewModel
            cell = sliderCell
        case .comments:
            let commentCell = tableView.dequeueReusableCell(withIdentifier: feedbackCommentsCellReuseID) as? FeedbackCommentsTableViewCell
            commentCell?.model = feedbackViewModel
            cell = commentCell
        case .submit:
            let submitCell = tableView.dequeueReusableCell(withIdentifier: feedbackSubmitCellReuseID) as? FeedbackSubmitTableViewCell
            submitCell?.model = feedbackViewModel
            cell = submitCell
        }

        guard let unwrappedCell = cell else {
            return UITableViewCell()
        }

        return unwrappedCell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

enum FeedbackTableViewCellType {
    case slider(type: FeedbackDimension)
    case comments
    case submit
}
