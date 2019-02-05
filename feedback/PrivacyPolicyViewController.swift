//
//  PrivacyPolicyViewController.swift
//  feedback
//
//  Created by James Little on 2/4/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    lazy var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(didSelectDoneButton))

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.title = "Privacy Policy"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://github.com/jameslittle230/thtr/blob/master/privacy.md")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    @objc
    func didSelectDoneButton() {
        dismiss(animated: true, completion: nil)
    }
}
