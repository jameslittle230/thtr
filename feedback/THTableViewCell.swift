//
//  THTableViewCell.swift
//  feedback
//
//  Created by James Little on 10/29/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class THTableViewCell: UITableViewCell {

    let THSelectedBackgroundView: UIView = create {
        $0.backgroundColor = Themer.DarkTheme.backgroundHighlighted
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = Themer.DarkTheme.text

        self.selectedBackgroundView = THSelectedBackgroundView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
