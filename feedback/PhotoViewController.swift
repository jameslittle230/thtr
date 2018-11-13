//
//  PhotoViewController.swift
//  feedback
//
//  Created by James Little on 11/6/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

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
            saveImage(image)
        } else {
            print("Something went wrong")
        }

        dismiss(animated: true, completion: nil)
    }

    func saveImage(_ image: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        let imagesRef = storageRef.child("reviewImages")

        guard let data = image.jpegData(compressionQuality: 0.4) else {
            return
        }

        let filePath = "\(Auth.auth().currentUser!.uid)/\(Date().timeIntervalSince1970)"

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        let uploadTask = imagesRef.child(filePath).putData(data, metadata: metadata)

        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }

        uploadTask.observe(.success) { snapshot in
            self.model?.extras["photo"] = snapshot.metadata?.path
        }

        uploadTask.observe(.failure) { snapshot in
            print("Failure")
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break

                    /* ... */

                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
