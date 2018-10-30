//
//  ReviewFeedCell.swift
//  feedback
//
//  Created by James Little on 10/2/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class ReviewFeedCell: THTableViewCell {

    let insetContentView: UIView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(hex: "#c5e1ea").cgColor
        $0.layer.borderWidth = (1.0 / UIScreen.main.scale) / 2

        // Shadow
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 4.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    let insetCVGradient: CAGradientLayer = create {
        $0.colors = [UIColor.init(hex: "#ad5389").cgColor, UIColor.init(hex: "#3c1053").cgColor]
        $0.cornerRadius = 8
    }

    let contentLabel: THLabel = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 8
        $0.font = UIFont.preferredFont(forTextStyle: .body)
//        $0.textColor = Themer.DarkTheme.text
    }

    let metaLabel: THLabel = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = Themer.DarkTheme.placeholderText
    }

    let stackView: UIStackView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(insetContentView)
        insetContentView.anchorToSuperviewAnchors(withHorizontalInset: 18, andVerticalInset: 9)

        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(metaLabel)

        insetContentView.addSubview(stackView)
        stackView.anchorToSuperviewAnchors(withInsetSize: 12)

        insetContentView.layer.insertSublayer(insetCVGradient, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        insetCVGradient.frame = insetContentView.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureAsNewReviewCell() {
        contentLabel.text = "New Review..."
        contentLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
        stackView.removeArrangedSubview(metaLabel)

        insetCVGradient.colors = [UIColor.init(hex: "#cc5333").cgColor, UIColor.init(hex: "#23074d").cgColor]
    }

    func configureWithReview(_ review: Review) {
        contentLabel.text = review.reviewText

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let formattedDate = formatter.string(from: review.updated)
        metaLabel.text = "\(review.show) • \(formattedDate)"

        if let rating = review.rating {
            metaLabel.text?.append(" • \(rating)★")
        }
    }

}
