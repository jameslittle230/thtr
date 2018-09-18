//
//  UIKit+Autolayout.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

extension UIView {
    func anchorToSuperviewAnchors() {
        let zeroInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.anchorToSuperviewAnchors(withInsets: zeroInsets)
    }
    
    func anchorToSuperviewAnchors(withInsets insets: UIEdgeInsets) {
        guard let superview = superview else {
            fatalError("Superview must be defined.")
        }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
            ])
    }
}
