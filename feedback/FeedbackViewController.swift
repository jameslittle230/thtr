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

    var productionViewModel: String?
    var feedbackViewModel: [FeedbackItemViewModel] = [
        FeedbackItemViewModel(type: .timeDistortion, value: 0),
        FeedbackItemViewModel(type: .spaceDistortion, value: 0),
        FeedbackItemViewModel(type: .bodyDistortion, value: 0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = "Give Feedback"

        tableView.register(FeedbackSliderTableViewCell.self, forCellReuseIdentifier: feedbackSliderCellReuseID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackSliderCellReuseID) as? FeedbackSliderTableViewCell else {
            fatalError()
        }

        cell.model = feedbackViewModel[indexPath.row]

        return cell
    }
}

typealias FeedbackValue = Float

enum FeedbackDimension {
    case timeDistortion
    case spaceDistortion
    case bodyDistortion
}

class FeedbackItemViewModel {
    var type: FeedbackDimension
    var value: FeedbackValue

    init(type: FeedbackDimension, value: FeedbackValue) {
        self.type = type
        self.value = value
    }
}

class FeedbackSliderTableViewCell: UITableViewCell {
    let slider = UISlider()

    var model: FeedbackItemViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false

        slider.minimumValue = 0
        slider.maximumValue = 7
        slider.value = 4
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right),
            slider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    @objc
    func sliderValueDidChange(sender: UISlider) {
        guard model != nil else {
            return
        }

        model!.value = sender.value
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
