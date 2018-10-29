//
//  THLabel.swift
//  feedback
//
//  Created by James Little on 10/29/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class THLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = Themer.DarkTheme.text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
