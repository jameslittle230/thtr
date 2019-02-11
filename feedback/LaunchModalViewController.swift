//
//  LaunchModalViewController.swift
//  feedback
//
//  Created by James Little on 2/11/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit

class LaunchModalViewController: UIViewController {

    let icon: UIImageView = create {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.4).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 8.0
        $0.clipsToBounds = false
    }

    let label: THLabel = create {
        let content = "Welcome to the THTR app, where you can record and track the shows you see. Upload a related photo (program, audience selfie, etc.), record you're review, and rate the performance. You can also track the performance mediation using the Distortion Sliders. These record the media distortion in each performance.\n\nTo record a show, select a title from the list of performances. Be sure to select the correct day and time for the performance and start reviewing!"
        $0.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: content)

        var style = NSMutableParagraphStyle()
        style.lineSpacing = 8 // change line spacing between paragraph like 36 or 48
//        style.minimumLineHeight = 12 // change line spacing between each line like 30 or 40
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: content.count))

        $0.attributedText = attributedText
    }

    var mainStackView: UIStackView = create {
        $0.spacing = 8
        $0.axis = .vertical
//        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Themer.DarkTheme.background
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "About this App"

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(icon)
        mainStackView.addArrangedSubview(label)

        mainStackView.anchorToSuperviewAnchors(withHorizontalInset: 12, andVerticalInset: 128)

        NSLayoutConstraint.activate([
//            icon.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.5),
//            icon.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor),
            icon.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.25)
        ])
    }

    @objc
    func didSelectDoneButton() {
        dismiss(animated: true, completion: nil)
    }
}
