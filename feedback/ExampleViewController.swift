//
//  ExampleViewController.swift
//  feedback
//
//  Created by James Little on 9/24/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    let label: THLabel = create {
        $0.text = "This is a new screen of the app. Other things will go here, but not yet ;)"
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        label.anchorToSuperviewAnchors()
    }
}
