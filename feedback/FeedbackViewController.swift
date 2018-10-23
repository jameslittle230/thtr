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

    let collectionView = FeedbackCollectionView()

    var keyboardVisible = false

    var model: Review? {
        didSet {
            if !mainInput.hasText {
                mainInput.text = model?.reviewText
            }
        }
    }

    var reviewedShow: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Write a Review"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)

        view.addSubview(stackView)
        stackView.addArrangedSubview(mainInput)
        stackView.addArrangedSubview(collectionView)
        view.backgroundColor = UIColor(hex: "#072028")

        if #available(iOS 11.0, *) {
            innerViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                innerViewBottomConstraint
                ])
        } else {
            // Fallback on earlier versions
        }

        collectionView.viewController = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !keyboardVisible {
            mainInput.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveCurrentModel()
        super.viewWillDisappear(true)
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

    func saveCurrentModel() {
        guard var review = model else {
            self.model = Review(withShow: reviewedShow ?? "") // this could probably be better?
            saveCurrentModel()
            return
        }

        guard mainInput.hasText else {
            return
        }

        review.reviewText = mainInput.text
        review.save()
    }
}
