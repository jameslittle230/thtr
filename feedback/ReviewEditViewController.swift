//
//  FeedbackViewController.swift
//  feedback
//
//  Created by James Little on 8/30/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class ReviewEditViewController: UIViewController {

    let saveButton: UIBarButtonItem = create {
        $0.action = #selector(saveAndExitToRoot)
        $0.title = "Save"
    }

    let stackView: UIStackView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
    }

    lazy var innerViewBottomConstraint = NSLayoutConstraint()

    let mainInput: UITextView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEditable = true
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        $0.textColor = UIColor(white: 1, alpha: 0.9)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    let actionBar = ActionBarView()

    var keyboardVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let review = GlobalReviewCoordinator.getCurrentReview() else {
            // alert
            return
        }

        navigationItem.title = "Write a Review"
        navigationItem.leftBarButtonItem = saveButton

        view.addSubview(stackView)
        stackView.addArrangedSubview(mainInput)
        stackView.addArrangedSubview(actionBar)

        mainInput.text = review.reviewText ?? ""

        view.backgroundColor = Themer.DarkTheme.background

        innerViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            innerViewBottomConstraint
        ])

        actionBar.parentViewController = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !keyboardVisible {
            mainInput.becomeFirstResponder()
        }
    }

    @objc
    func keyboardWillAppear(_ sender: NSNotification) {
        guard keyboardVisible == false else {
            return
        }

        keyboardVisible = true

        guard let info = sender.userInfo as? [String: AnyObject],
            let kbSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
                return
        }

        innerViewBottomConstraint.isActive = false
        innerViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kbSize.height)
        innerViewBottomConstraint.isActive = true

        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @objc
    func saveAndExitToRoot() {
        saveCurrentModel()
        navigationController?.popToRootViewController(animated: true)
    }

    @objc
    func saveCurrentModel() {
        GlobalReviewCoordinator.getCurrentReview()?.reviewText = mainInput.text
        GlobalReviewCoordinator.getCurrentReview()?.save()
    }
}
