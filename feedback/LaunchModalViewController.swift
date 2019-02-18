//
//  LaunchModalViewController.swift
//  feedback
//
//  Created by James Little on 2/11/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit

class LaunchModalViewController: UITableViewController {

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

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
    }

    let label: THLabel = create {
        let content = "Welcome to the THTR app, where you can record and track the shows you see. Upload a related photo (program, audience selfie, etc.), record you're review, and rate the performance. You can also track the performance mediation using the Distortion Sliders. These record the media distortion in each performance.\n\nTo record a show, select a title from the list of performances. Be sure to select the correct day and time for the performance and start reviewing!"
        $0.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: content)

        var style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: content.count))

        $0.attributedText = attributedText

        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false

        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "About This App"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.row == 0 {
            cell.contentView.addSubview(icon)
            icon.anchorToSuperviewAnchors(withHorizontalInset: 0, andVerticalInset: 36)
        } else {
            cell.contentView.addSubview(label)
            label.anchorToSuperviewAnchors(withHorizontalInset: 24, andVerticalInset: 12)
        }
        cell.isUserInteractionEnabled = false
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    @objc
    func didSelectDoneButton() {
        dismiss(animated: true, completion: nil)
    }
}
