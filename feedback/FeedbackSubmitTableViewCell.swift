//
//  FeedbackSubmitTableViewCell.swift
//  feedback
//
//  Created by James Little on 9/11/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackSubmitTableViewCell: UITableViewCell {
    let button = UIButton(type: .system)

    var model: FeedbackViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Text Input setup
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.isUserInteractionEnabled = true
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)

        // Layout constraints
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.layoutMargins.right),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func didSelectButton() {
        button.isEnabled = false
        model?.write { error, committed, data in
            if error == nil {
//                UIAlertController(title: "Data Transaction Failed", message: ":(", preferredStyle: .alert).show(, sender: nil)
            }
        }
    }
}
