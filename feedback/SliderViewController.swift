//
//  SliderViewController.swift
//  feedback
//
//  Created by James Little on 11/15/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class SliderViewController: UITableViewController, ActionBarViewController {

    var model: Review?

    var viewModels: [FeedbackDimension: FeedbackItemViewModel] = [
        .timeDistortion: FeedbackItemViewModel(type: .timeDistortion, value: 0),
        .spaceDistortion: FeedbackItemViewModel(type: .spaceDistortion, value: 0),
        .bodyDistortion: FeedbackItemViewModel(type: .bodyDistortion, value: 0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FeedbackSliderTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        if let sliderVals = model?.extras["sliders"] as? Int {
            viewModels[.timeDistortion]?.value = Float(sliderVals / 100) // 100s digit
            viewModels[.spaceDistortion]?.value = Float(sliderVals / 10 % 10) // 10s digit
            viewModels[.bodyDistortion]?.value = Float(sliderVals % 10) // 1s digit
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let time = floor(viewModels[.timeDistortion]?.value ?? 0) * 100
        let space = floor(viewModels[.spaceDistortion]?.value ?? 0) * 10
        let body = floor(viewModels[.bodyDistortion]?.value ?? 0)

        if (time + space + body) > 0 {
            model?.extras["sliders"] = time + space + body
        }

        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? FeedbackSliderTableViewCell ?? FeedbackSliderTableViewCell()

        let type: FeedbackDimension = {
            switch indexPath.row {
            case 0:
                return .timeDistortion
            case 1:
                return .spaceDistortion
            case 2:
                return .bodyDistortion
            default:
                fatalError()
            }
        }()

        cell.model = viewModels[type]

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

class FeedbackSliderTableViewCell: THTableViewCell {
    let slider: UISlider = create {
        $0.minimumValue = 0
        $0.maximumValue = 9
        $0.isUserInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let typeLabel: THLabel = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

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
            slider.value = model.value
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Slider setup
        contentView.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)

        // Title setup
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            slider.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: contentView.layoutMargins.left * 3),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])

        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left * 3),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
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
