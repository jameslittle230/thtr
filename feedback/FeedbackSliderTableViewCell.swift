//
//  FeedbackSliderTableViewCell.swift
//  feedback
//
//  Created by James Little on 9/4/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

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
