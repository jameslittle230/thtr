//
//  SignInViewController.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UITableViewController {

    let emailInput: UITextField = create {
        $0.placeholder = "james@example.com"
        $0.textAlignment = .right

//        $0.isUserInteractionEnabled = true
//        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let emailLabel: UILabel = create {
        $0.text = "Email"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordInput: UITextField = create {
        $0.placeholder = "Password"
        $0.textAlignment = .right
        $0.isSecureTextEntry = true

//        $0.isUserInteractionEnabled = true
//        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordLabel: UILabel = create {
        $0.text = "Password"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let emailField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cellReuseId = "reuseIdentifier"

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.addArrangedSubview(passwordLabel)
        passwordField.addArrangedSubview(passwordInput)

        emailField.addArrangedSubview(emailLabel)
        emailField.addArrangedSubview(emailInput)

        navigationItem.title = "Sign In"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        var subview: UIStackView?

        switch indexPath.row {
        case 0:
            subview = emailField
        case 1:
            subview = passwordField
        case 2:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Sign In"
            cell.textLabel?.textColor = self.view.tintColor
            subview = nil
        default:
            fatalError("That's not how math works")
        }

        if let subview = subview {
            cell.contentView.addSubview(subview)

            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                subview.widthAnchor.constraint(equalTo: cell.widthAnchor, constant: -32),
                subview.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16)
                ])
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.row == 2 else {
            return
        }

        guard let email = emailInput.text, let password = passwordInput.text else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            print(user)
        }
    }
}
