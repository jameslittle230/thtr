//
//  UIKit+Autolayout.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

extension UIView {

    @discardableResult
    func anchorToSuperviewAnchors()
        -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {
            let zeroInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return self.anchorToSuperviewAnchors(withInsets: zeroInsets)
    }

    @discardableResult
    func anchorToSuperviewAnchors(withInsetSize size: CGFloat)
        -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {
            let insets = UIEdgeInsets(top: size, left: size, bottom: -size, right: -size)
            return self.anchorToSuperviewAnchors(withInsets: insets)
    }

    @discardableResult
    func anchorToSuperviewAnchors(withHorizontalInset horiz: CGFloat, andVerticalInset vert: CGFloat)
        -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {
            let insets = UIEdgeInsets(top: vert, left: horiz, bottom: -horiz, right: -vert)
            return self.anchorToSuperviewAnchors(withInsets: insets)
    }

    @discardableResult
    func anchorToSuperviewAnchors(withInsets insets: UIEdgeInsets)
        -> (NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint, NSLayoutConstraint) {

            guard let superview = superview else {
                fatalError("Superview must be defined.")
            }

            let constraints = (
                top: topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                bottom: bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
                leading: leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
                trailing: trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
            )

            NSLayoutConstraint.activate([constraints.top, constraints.bottom, constraints.leading, constraints.trailing])

            return constraints
    }
}
