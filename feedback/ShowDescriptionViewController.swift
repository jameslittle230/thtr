//
//  ShowDescriptionViewController.swift
//  feedback
//
//  Created by James Little on 2/25/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit

class ShowDescriptionViewController: UITableViewController {

    enum Section: CaseIterable {
        case fields
        case actions

        static var count: Int {
            return self.allCases.count
        }

        static func get(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }

    var model: Show
    var array: [(String, Any)] = []

    init(withShow show: Show) {
        self.model = show
        super.init(nibName: nil, bundle: nil)

        array = [
            ("Title", show.title),
            ("Date", show.date),
            ("Creator", show.creator),
            ("Venue", show.venue)
        ]
    }

    required init?(coder aDecoder: NSCoder) { fatalError("die") }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = model.title
        navigationItem.largeTitleDisplayMode = .always

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.register(ShowDescriptionLineItemCell.self, forCellReuseIdentifier: "reuseIdentifier2")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.get(section) {
        case .fields:
            return array.count
        case .actions:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.get(indexPath.section) {
        case .fields:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath) as? ShowDescriptionLineItemCell else {
                return UITableViewCell()
            }

            cell.model = array[indexPath.row]
            return cell
        case .actions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? THTableViewCell else {
                return UITableViewCell()
            }

            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Choose a different show"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section.get(indexPath.section) {
        case .fields:
            return
        case .actions:
            navigationController?.pushViewController(ShowSelectionViewController(), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

class ShowDescriptionLineItemCell: THTableViewCell {
    var model: (String, Any)? {
        didSet {
            guard let key = model?.0,
                let value = model?.1 else {
                    return
            }

            keyLabel.text = key
            valueLabel.text = {
                if let dateValue = value as? Date {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .long
                    formatter.timeStyle = .none
                    return formatter.string(from: dateValue)
                } else {
                    return "\(value)"
                }
            }()
        }
    }

    let keyLabel: THLabel = create {
        $0.textColor = Themer.DarkTheme.placeholderText
    }

    let valueLabel: THLabel = create {
        $0.textAlignment = .right
    }

    let stackview: UIStackView = create {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(stackview)
        stackview.anchorToSuperviewAnchors(withHorizontalInset: 16, andVerticalInset: 8)
        stackview.addArrangedSubview(keyLabel)
        stackview.addArrangedSubview(valueLabel)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("die") }
}
