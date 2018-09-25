//
//  FeedbackViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    let stackView: UIStackView = create {
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var innerViewBottomConstraint = NSLayoutConstraint()

    let mainInput: UITextView = create {
        $0.backgroundColor = UIColor.lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEditable = true
        $0.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }

    let optionsCollectionView: UICollectionView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = "Give Feedback"

        view.addSubview(stackView)
        stackView.addArrangedSubview(mainInput)
        view.backgroundColor = .white


        if #available(iOS 11.0, *) {
            innerViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                innerViewBottomConstraint
                ])

            mainInput.anchorToSuperviewAnchors()
        } else {
            // Fallback on earlier versions
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc
    func keyboardDidAppear(_ sender: NSNotification) {
        guard let info = sender.userInfo as? [String: AnyObject],
            let kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
                return
        }

        innerViewBottomConstraint.constant = -kbSize.height

        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
