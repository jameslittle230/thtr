//
//  FeedbackCollectionView.swift
//  feedback
//
//  Created by James Little on 9/24/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class FeedbackCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let cellHeight: CGFloat = 50
    let cellWidth: CGFloat = 50

    let cellIdentifier = "UICollectionViewCellReuseIdentifier"

    let flowLayout: UICollectionViewFlowLayout = create {
        $0.scrollDirection = .horizontal
    }

    var viewController: UIViewController?

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self

        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hex: "#072028")

        self.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let imageView = UIImageView.init(image: UIImage(imageLiteralResourceName: "AppIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: cellHeight),
            imageView.widthAnchor.constraint(equalToConstant: cellWidth)
            ])

        cell.contentView.addSubview(imageView)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vctrl = viewController else {
            return
        }

        vctrl.navigationController?.pushViewController(ExampleViewController(), animated: true)
    }
}
