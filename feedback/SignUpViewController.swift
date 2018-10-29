//
//  SignUpViewController.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UITableViewController {

    let emailInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "james@example.com", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.autocapitalizationType = .none
        $0.keyboardType = .emailAddress
        $0.autocorrectionType = .no
    }

    let emailLabel: THLabel = create {
        $0.text = "Email"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "••••••••", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.isSecureTextEntry = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    let passwordConfirmInput: UITextField = create {
        $0.attributedPlaceholder = NSAttributedString(string: "••••••••", attributes: [.foregroundColor: Themer.DarkTheme.placeholderText])
        $0.textAlignment = .right
        $0.isSecureTextEntry = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    let emailField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordLabel: THLabel = create {
        $0.text = "Password"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordConfirmLabel: THLabel = create {
        $0.text = "Confirm Password"
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordField: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordConfirmField: UIStackView = create {
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

        emailField.addArrangedSubview(emailLabel)
        emailField.addArrangedSubview(emailInput)

        passwordField.addArrangedSubview(passwordLabel)
        passwordField.addArrangedSubview(passwordInput)

        passwordConfirmField.addArrangedSubview(passwordConfirmLabel)
        passwordConfirmField.addArrangedSubview(passwordConfirmInput)

        navigationItem.title = "Sign Up"

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: cellReuseId)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailInput.becomeFirstResponder()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            subview = passwordConfirmField
        case 3:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Sign Up"
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

        guard indexPath.row == 3 else {
            return
        }

        guard let email = emailInput.text,
            let password = passwordInput.text,
            let passwordConf = passwordConfirmInput.text else {
            return
        }

        guard password == passwordConf else {
            let alert = UIAlertController(title: "Passwords must match.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.passwordInput.text = ""
                self.passwordConfirmInput.text = ""
                self.passwordInput.becomeFirstResponder()
            })
            self.present(alert, animated: true, completion: nil)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            guard let user = authResult?.user else {
                let alert = UIAlertController(title: "Error", message: "User could not be created.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Bummer.", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            NotificationCenter.default.post(
                Notification(name: Notification.Name(rawValue: "UserSetNotification"),
                             object: user, userInfo: nil))

            self.navigationController?.popViewController(animated: true)
        }
    }
}
