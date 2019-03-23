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
    let cellWidth: CGFloat = 40

    let cellIdentifier = "UICollectionViewCellReuseIdentifier"

    let flowLayout: UICollectionViewFlowLayout = create {
        $0.scrollDirection = .horizontal
    }

    var model: Review?

    let cells: [ActionBarItem] = [
        ActionBarItem(
            key: "show",
            image: UIImage(named: "star-filled"),
            label: THLabel(),
            color: UIColor(hex: "#c43636"),
            viewController: ShowSelectionViewController()),

        ActionBarItem(
            key: "rating",
            image: UIImage(named: "star-filled"),
            label: THLabel(),
            color: UIColor(hex: "#eacd3e"),
            viewController: RatingViewController()),

        ActionBarItem(
            key: "photo",
            image: UIImage(named: "camera"),
            label: THLabel(),
            color: UIColor(hex: "#50b9e2"),
            viewController: PhotoViewController()),
        ActionBarItem(
            key: "sliders",
            image: UIImage(named: "sliders"),
            label: THLabel(),
            color: UIColor(hex: "#f7893b"),
            viewController: SliderViewController())
    ]

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
        cell.backgroundColor = .clear
        let item = cells[indexPath.row]

        cell.model = item

        if model?.extras[item.key] != nil {
            cell.backgroundColor = UIColor(hex: "#ea4f3e", alpha: 0.7)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = cells[indexPath.row]
        parentViewController?.navigationController?.pushViewController(item.viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

struct ActionBarItem {
    let key: String
    let image: UIImage?
    let label: THLabel?
    let color: UIColor
    var viewController: UIViewController
}

class FeedbackCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }

    var model: ActionBarItem? {
        didSet {
            if let model = model {
                imageView.tintColor = model.color
                imageView.image = model.image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.anchorToSuperviewAnchors(withInsetSize: 8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
