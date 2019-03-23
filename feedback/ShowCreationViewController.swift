//
//  ShowCreationViewController.swift
//  feedback
//
//  Created by James Little on 2/25/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit
import Firebase

class ShowCreationViewController: UITableViewController {

    enum CellType {
        case field(ShowCreationLineItemViewModel)
        case confirm
    }

    let cells: [CellType] = [
        .field(ShowCreationLineItemViewModel(key: "title", userVisibleKey: "Title", value: .text(""))),
        .field(ShowCreationLineItemViewModel(key: "date", userVisibleKey: "Date", value: .date(Date()))),
        .field(ShowCreationLineItemViewModel(key: "creator", userVisibleKey: "Creator", value: .text(""))),
        .field(ShowCreationLineItemViewModel(key: "venue", userVisibleKey: "Venue", value: .text(""))),
        .confirm
    ]

    let submitButton: UIButton = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Submit New Show", for: .normal)
        $0.setTitleColor(Themer.DarkTheme.tint, for: .normal)
        $0.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShowCreationTableViewCell.self, forCellReuseIdentifier: "showCreationCellReuseIdentifier")
        tableView.register(THTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {

        case let .field(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "showCreationCellReuseIdentifier", for: indexPath) as? ShowCreationTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell

        case .confirm:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? THTableViewCell else {
                return UITableViewCell()
            }
            cell.contentView.addSubview(submitButton)
            submitButton.anchorToSuperviewAnchors(withHorizontalInset: 0, andVerticalInset: 12)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if let cell = tableView.cellForRow(at: indexPath) as? ShowCreationTableViewCell {
             cell.wasSelected()
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    @objc
    func submitForm() {
        self.view.endEditing(true)
        var dict: [String: Any] = [:]
        for cell in cells {
            if case let CellType.field(viewModel) = cell {
                let value = viewModel.getValue()
                if value as? String == "" {
                    // alert and return
                }

                dict[viewModel.key] = viewModel.getValue()
            }
        }

        if let model = Show(fromDictionary: dict) {
            model.save()
            navigationController?.popViewController(animated: true)
        }
    }
}

class ShowCreationLineItemViewModel {
    enum Data {
        case text(String)
        case date(Date)
    }

    let key: String
    let userVisibleKey: String
    var value: Data

    func getValue() -> Any {
        switch value {
        case let .text(output): return output
        case let .date(output): return output
        }
    }

    init(key: String, userVisibleKey: String, value: Data) {
        self.key = key
        self.userVisibleKey = userVisibleKey
        self.value = value
    }
}

class ShowCreationTableViewCell: THTableViewCell {
    let label: THLabel = create {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = Themer.DarkTheme.placeholderText
    }

    let textInput: UITextField = create {
        $0.textAlignment = .right
    }

    let dateLabel: UITextField = create {
        $0.textAlignment = .right
    }

    let datePicker: UIDatePicker = create {
        $0.datePickerMode = .date
    }

    let datePickerToolbar: UIToolbar = create {
        $0.barStyle = .blackTranslucent
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let stackView: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var viewModel: ShowCreationLineItemViewModel? {
        didSet {
            if oldValue == nil {
                setUpConstraints()
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textInput.delegate = self

        stackView.addArrangedSubview(label)
        contentView.addSubview(stackView)

        dateLabel.inputView = datePicker

        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDone))
        datePickerToolbar.setItems([doneButtonItem], animated: false)
        dateLabel.inputAccessoryView = datePickerToolbar

        stackView.anchorToSuperviewAnchors(withHorizontalInset: 16, andVerticalInset: 12)
    }

    func setUpConstraints() {
        guard let vmdl = viewModel else {
            return
        }

        label.text = vmdl.userVisibleKey
        stackView.removeArrangedSubview(textInput)
        stackView.removeArrangedSubview(dateLabel)

        switch vmdl.value {
        case let .date(dateValue):
            stackView.addArrangedSubview(dateLabel)
            dateLabel.text = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter.string(from: dateValue)
            }()
        case let .text(textValue):
            stackView.addArrangedSubview(textInput)
            textInput.text = textValue
        }
    }

    func wasSelected() {
        guard let vmdl = viewModel else {
            return
        }

        switch vmdl.value {
        case .text:
            textInput.becomeFirstResponder()
        case .date:
            dateLabel.becomeFirstResponder()
        }
    }

    @objc
    func datePickerDone() {
        print(datePicker.date)
        dateLabel.resignFirstResponder()
        viewModel?.value = .date(datePicker.date)
        self.setUpConstraints()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShowCreationTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.value = .text(textField.text ?? "")
    }
}
