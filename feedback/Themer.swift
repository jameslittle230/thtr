//
//  Themer.swift
//  feedback
//
//  Created by James Little on 10/11/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class Themer {
    class func configure() {
        UITableView.appearance().backgroundColor = UIColor(hex: "#072028")
        UITableViewCell.appearance().backgroundColor = UIColor(hex: "#072028")

        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().tintColor = UIColor(hex: "#e56447")

        UITextView.appearance().backgroundColor = UIColor(hex: "#072028")
    }
}
