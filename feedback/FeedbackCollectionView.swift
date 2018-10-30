//
//  FeedbackCollectionView.swift
//  feedback
//
//  Created by James Little on 9/24/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellHeight: CGFloat = 40
    let cellWidth: CGFloat = 40

    let cellIdentifier = "UICollectionViewCellReuseIdentifier"

    let flowLayout: UICollectionViewFlowLayout = create {
        $0.scrollDirection = .horizontal
    }

    var model: Review?

    let cells: [ActionBarItem] = [
        ActionBarItem(key: "rating", image: UIImage(named: "star-filled"), viewController: RatingViewController())
    ]

    var parentViewController: FeedbackViewController?

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self

        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        self.setContentHuggingPriority(.required, for: .vertical)
        self.backgroundColor = UIColor(hex: "#072028")

        self.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let item = cells[indexPath.row]

        let imageView = UIImageView.init(image: item.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        cell.contentView.addSubview(imageView)
        imageView.anchorToSuperviewAnchors(withInsetSize: 8)

        if let value = model?.loadedDict?[item.key] {
            cell.backgroundColor = .red
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = cells[indexPath.row]
        item.viewController.model = model
        parentViewController?.navigationController?.pushViewController(item.viewController, animated: true)
        parentViewController?.feedbackWasEdited()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

struct ActionBarItem {
    let key: String
    let image: UIImage?
    let viewController: RatingViewController
}
