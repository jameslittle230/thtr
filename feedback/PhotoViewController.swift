//
//  PhotoViewController.swift
//  feedback
//
//  Created by James Little on 11/6/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, ActionBarViewController {
    var model: Review?

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            print(image)
        } else {
            print("Something went wrong")
        }

        dismiss(animated: true, completion: nil)
    }
}
