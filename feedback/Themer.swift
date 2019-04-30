//
//  Themer.swift
//  feedback
//
//  Created by James Little on 10/11/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class Themer {
    struct DarkTheme {
        static let background = UIColor(hex: "#072028")
        static let backgroundHighlighted = UIColor(hex: "#0b303d")
        static let tint = UIColor(hex: "#e56447")
        static let text = UIColor(white: 1, alpha: 0.9)
        static let placeholderText = UIColor(white: 1, alpha: 0.4)
    }

    class func configure() {
        UITableView.appearance().backgroundColor = Themer.DarkTheme.background
        UICollectionView.appearance().backgroundColor = Themer.DarkTheme.background
        THTableViewCell.appearance().backgroundColor = Themer.DarkTheme.background

        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().tintColor = Themer.DarkTheme.tint

        UITextView.appearance().backgroundColor = Themer.DarkTheme.background

        UITableView.appearance().separatorColor = Themer.DarkTheme.placeholderText

        UITextField.appearance().tintColor = Themer.DarkTheme.tint
        UITextField.appearance().textColor = Themer.DarkTheme.text
    }
}
