//
//  FeedbackViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackViewController: UITableViewController {

    var productionViewModel: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = "Give Feedback"
    }
}
