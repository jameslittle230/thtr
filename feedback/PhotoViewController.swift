//
//  PhotoViewController.swift
//  feedback
//
//  Created by James Little on 11/15/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PhotoViewController: UITableViewController, ActionBarViewController {

    let maxFileSizeInBytes: Int64 = 3 * 1024 * 1024

    let cellReuseId = "UITableViewCellReuseIdentifier"

    var model: Review?

    let imageView: UIImageView = create {
        $0.image = nil
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var imageVisible = false {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(THTableViewCell.self, forCellReuseIdentifier: cellReuseId)

        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension

        if let imagePath = model?.extras["photo"] as? String {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child(imagePath)

            imageRef.getData(maxSize: maxFileSizeInBytes) { data, error in
                if let error = error {
                    print(error)
                    Analytics.logEvent("image_download_error", parameters: nil)
                } else {
                    self.imageView.image = UIImage(data: data!)
                    self.imageVisible = true
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.imageVisible ? 1 : 0
        case 1:
            return 2
        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) ?? THTableViewCell(frame: .zero)

        switch indexPath.section {
        case 0:
            if self.imageVisible {
                cell.contentView.addSubview(imageView)
                let aspect = (imageView.image?.size.width ?? 1) / (imageView.image?.size.height ?? 1)

                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalTo: cell.widthAnchor),
                    imageView.heightAnchor.constraint(equalToConstant: cell.bounds.width / aspect),
                    cell.contentView.heightAnchor.constraint(equalTo: imageView.heightAnchor)
                    ])
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Take a Picture"
            case 1:
                cell.textLabel?.text = "Select a Picture"
            default:
                fatalError()
            }
        default:
            fatalError()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self

        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                myPickerController.sourceType = .camera
                present(myPickerController, animated: true, completion: nil)
            }
        } else {
            myPickerController.sourceType = .photoLibrary
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
            imageView.image = image
            imageVisible = true
            self.tableView.reloadData()
        } else {
            print("Something went wrong")
        }

        dismiss(animated: true, completion: nil)
    }

    func saveImage(_ image: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        let imagesRef = storageRef.child("reviewImages")

        guard var data = image.jpegData(compressionQuality: 0.4) else {
            return
        }

        if data.count > maxFileSizeInBytes {
            guard let smallerData = image.jpegData(compressionQuality: 0.2) else {
                return
            }

            data = smallerData // There should maybe be a better way of checking this but oh well
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
                switch StorageErrorCode(rawValue: error.code)! {
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
