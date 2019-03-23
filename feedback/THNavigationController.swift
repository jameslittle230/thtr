//
//  THNavigationController.swift
//  feedback
//
//  Created by James Little on 2/11/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit

class THNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ShowCollector.startListener()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UserDefaults.standard.bool(forKey: "firstLaunchCompleted") {
            let modalVC = LaunchModalViewController()
            let popoverRootVC = UINavigationController(rootViewController: modalVC)
            present(popoverRootVC, animated: true)
            UserDefaults.standard.set(true, forKey: "firstLaunchCompleted")
        }
    }

}
