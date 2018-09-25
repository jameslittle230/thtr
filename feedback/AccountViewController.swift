//
//  AccountViewController.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UITableViewController {

    enum CellTypes {
        case signUp
        case signIn
        case changePassword
        case signOut
    }

    var visibleCells = [
        CellTypes.signIn,
        CellTypes.signUp
    ]

    let defaultNavigationTitle = "Account"

    let cellReuseId = "reuseIdentifier"

    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = defaultNavigationTitle

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)

        NotificationCenter.default.addObserver(self, selector: #selector(userWasSet),
                                               name: Notification.Name("UserSetNotification"), object: nil)

        userWasSet()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        let cellType = visibleCells[indexPath.row]

        switch cellType {
        case .changePassword:
            cell.textLabel?.text = "Change Password"
        case .signIn:
            cell.textLabel?.text = "Sign In"
        case .signUp:
            cell.textLabel?.text = "Sign Up"
        case .signOut:
            cell.textLabel?.text = "Sign Out"
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = visibleCells[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        switch cellType {
        case .changePassword:
//            present(SignInViewController(), animated: true, completion: nil)
            return
        case .signIn:
            navigationController?.pushViewController(SignInViewController(), animated: true)
        case .signUp:
            navigationController?.pushViewController(SignUpViewController(), animated: true)
        case .signOut:
            signOut()
        }
    }

    @objc
    func didSelectDoneButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func userWasSet() {
        if let user = Auth.auth().currentUser {
            navigationItem.title = user.email
            self.visibleCells = [.changePassword, .signOut]
        } else {
            navigationItem.title = "Account"
            self.visibleCells = [.signIn, .signUp]
        }

        tableView.reloadData()
    }

    func signOut() {
        do { try Auth.auth().signOut() } catch {}
        userWasSet()
    }

}
