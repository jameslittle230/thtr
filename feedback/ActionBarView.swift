//
//  FeedbackCollectionView.swift
//  feedback
//
//  Created by James Little on 9/24/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class ActionBarView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellHeight: CGFloat = 40

    let cellIdentifier = "UICollectionViewCellReuseIdentifier"

    let flowLayout: UICollectionViewFlowLayout = create {
        $0.scrollDirection = .horizontal
        $0.estimatedItemSize = CGSize(width: 20, height: 20)
    }

    var cells: [ActionBarItem] = [
        ActionBarItem(
            key: "show",
            image: UIImage(named: "tickets"),
            color: UIColor(hex: "#50b9e2"),
            viewController: ShowSelectionViewController()),

        ActionBarItem(
            key: "rating",
            image: UIImage(named: "star-filled"),
            color: UIColor(hex: "#eacd3e"),
            viewController: RatingViewController()),

        ActionBarItem(
            key: "photo",
            image: UIImage(named: "camera"),
            color: UIColor(hex: "#c43636"),
            viewController: PhotoViewController()),
        ActionBarItem(
            key: "sliders",
            image: UIImage(named: "sliders"),
            color: UIColor(hex: "#f7893b"),
            viewController: SliderViewController())
    ]

    var model: Review?

    var parentViewController: ReviewEditViewController?

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self

        register(FeedbackCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        self.setContentHuggingPriority(.required, for: .vertical)
        self.backgroundColor = Themer.DarkTheme.background

        self.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FeedbackCollectionViewCell ?? FeedbackCollectionViewCell()

        if let model = model {
            cells[indexPath.row].setActiveStateFromReview(model)
        }

        cell.model = cells[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentViewController?.navigationController?.pushViewController(cells[indexPath.row].viewController, animated: true)
    }
}

// MARK: - Action Bar Item Class

struct ActionBarItem {

    enum State {
        case inactive
        case dot
        case text(value: String)
    }

    let key: String
    let image: UIImage?
    let color: UIColor
    let viewController: UIViewController

    var activeState: State = .inactive

    mutating func setActiveStateFromReview(_ review: Review) {
        if let value = review.dict[key] {
            switch key {
            case "rating":
                activeState = .text(value: "\(value)")
            case "show":
                if let key = value as? String, let showName = ShowCollector.instance.shows[key]?.title {
                    activeState = .text(value: showName)
                }
            default:
                activeState = .dot
            }
        }
    }

    init(key: String, image: UIImage?, color: UIColor, viewController: UIViewController) {
        self.key = key
        self.image = image
        self.color = color
        self.viewController = viewController
    }
}

class FeedbackCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    let label: THLabel = create {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }

    let stackView: UIStackView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 6
    }

    var model: ActionBarItem? {
        didSet {
            updateDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)

        let dimension: CGFloat = 28
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: dimension),
            imageView.widthAnchor.constraint(equalToConstant: dimension)
        ])

        stackView.addArrangedSubview(imageView)
        stackView.anchorToSuperviewAnchors(withHorizontalInset: 4, andVerticalInset: 6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateDisplay() {
        imageView.image = nil
        backgroundColor = .clear
        label.text = nil
        stackView.removeArrangedSubview(label)

        if let model = model {
            imageView.tintColor = model.color
            imageView.image = model.image?.withRenderingMode(.alwaysTemplate)

            switch model.activeState {
            case .inactive:
                break
            case .dot:
                self.backgroundColor = UIColor(hex: "#ea4f3e", alpha: 0.3)
                self.layer.cornerRadius = 8
            case let .text(value: value):
                stackView.addArrangedSubview(label)
                label.text = value
                label.textColor = model.color
            }

            print(imageView.intrinsicContentSize)
            print(label.intrinsicContentSize)
            stackView.layoutIfNeeded()
            print(stackView.frame)
            print(stackView.intrinsicContentSize)
            print(self.intrinsicContentSize)
        }
    }
}
