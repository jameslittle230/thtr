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
    let typeLabel = UILabel()

    var model: FeedbackItemViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            let label = { () -> String in
                switch model.type {
                case .bodyDistortion:
                    return "Bodies"
                case .spaceDistortion:
                    return "Space"
                case .timeDistortion:
                    return "Time"
                }
            }()

            typeLabel.text = label
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Slider setup
        contentView.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false

        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)

        // Title setup
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 6),
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])

        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3)
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

class FeedbackCommentsTableViewCell: UITableViewCell {
    let textInput = UITextView()
    let typeLabel = UILabel()

    var model: String = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Text Input setup
        contentView.addSubview(textInput)
        textInput.translatesAutoresizingMaskIntoConstraints = false

        textInput.isUserInteractionEnabled = true
        textInput.isEditable = true
        textInput.text = "asdfasdf"
        textInput.font = UIFont.preferredFont(forTextStyle: .body)

        // Title setup
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.text = "Comments"

        // Layout constraints
        NSLayoutConstraint.activate([
            textInput.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 6),
            textInput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3),
            textInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right),
            textInput.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            textInput.heightAnchor.constraint(equalToConstant: 80)
            ])

        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3)
            ])
    }

    @objc
    func inputValueDidChange(sender: UITextField) {
        model = sender.text ?? ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
