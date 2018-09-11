//
//  FeedbackCommentsTableViewCell.swift
//  feedback
//
//  Created by James Little on 9/4/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackCommentsTableViewCell: UITableViewCell, UITextViewDelegate {
    let textInput = UITextView()
    let typeLabel = UILabel()

    var model: FeedbackViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Text Input setup
        contentView.addSubview(textInput)
        textInput.translatesAutoresizingMaskIntoConstraints = false

        textInput.isUserInteractionEnabled = true
        textInput.isEditable = true
        textInput.text = "..."
        textInput.font = UIFont.preferredFont(forTextStyle: .body)
        textInput.delegate = self

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

    func textViewDidChange(_ textView: UITextView) {
        model?.comments = textView.text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
