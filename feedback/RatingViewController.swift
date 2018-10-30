//
//  RatingViewController.swift
//  feedback
//
//  Created by James Little on 10/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    let starImageViews = [
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView()
    ]

    let stackView: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .blue
        $0.distribution = .fillEqually
    }

    var model: Review?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        navigationItem.title = "Rating"

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        _ = starImageViews.map { imageView in
            imageView.image = UIImage(named: "star-empty")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.yellow
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(starTapped))
            tapGestureRecognizer.numberOfTapsRequired = 1
            tapGestureRecognizer.numberOfTouchesRequired = 1
            stackView.addGestureRecognizer(tapGestureRecognizer)

            stackView.addArrangedSubview(imageView)
        }

        if let rating = model?.rating {
            setControlValue(rating)
        }

        // Do any additional setup after loading the view.
    }

    @objc
    func starTapped(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.view != nil else { return }

        if recognizer.state == .ended {
            let normalizedXCoord = Int(recognizer.location(in: stackView).x / stackView.bounds.width * 5) + 1
            setControlValue(normalizedXCoord)

            model?.rating = normalizedXCoord
            navigationController?.popViewController(animated: true)
        }
    }

    func setControlValue(_ value: Int) {
        for (index, star) in starImageViews.enumerated() {
            if index < value {
                star.image = UIImage(named: "star-filled")?.withRenderingMode(.alwaysTemplate)
            } else {
                star.image = UIImage(named: "star-empty")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
}
