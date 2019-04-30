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

class PhotoViewController: UICollectionViewController {

    private let sectionInsets = UIEdgeInsets(top: 32,
                                             left: 20.0,
                                             bottom: 0,
                                             right: 20.0)

    private var itemsPerRow: CGFloat = 2

    enum Section: CaseIterable {
        case photoList
        case actions

        static var count: Int {
            return self.allCases.count
        }

        static func get(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }

    static let maxFileSizeInBytes: Int64 = 3 * 1024 * 1024

    let THPhotoActionCellReuseId = "THPhotoActionCellReuseIdentifier"
    let THPhotoViewCellReuseId = "THPhotoViewCellReuseIdentifier"

    var photoPaths: [String] = ["test"]

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(THPhotoActionCell.self, forCellWithReuseIdentifier: THPhotoActionCellReuseId)
        collectionView.register(THPhotoViewCell.self, forCellWithReuseIdentifier: THPhotoViewCellReuseId)

        navigationItem.title = "Add a Photo"

        getNewDataAndReload()
    }

    func getNewDataAndReload() {
        let photoValue = GlobalReviewCoordinator.getCurrentReview()?.extras["photo"]

        if let imagePath = photoValue as? String {
            self.photoPaths = [imagePath]
        } else if let imagePathDict = photoValue as? [String: String] {
            self.photoPaths = Array(imagePathDict.values)
        }

        collectionView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section.get(section) {
        case .photoList:
            return photoPaths.count
        case .actions:
            return 2
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section.get(indexPath.section) {
        case .photoList:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: THPhotoViewCellReuseId, for: indexPath) as? THPhotoViewCell else {
                return UICollectionViewCell()
            }

            cell.imagePath = photoPaths[indexPath.row]
            return cell
        case .actions:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: THPhotoActionCellReuseId, for: indexPath) as? THPhotoActionCell else {
                return UICollectionViewCell()
            }

            switch indexPath.row {
            case 0:
                cell.label.text = "Take Photo"
            case 1:
                cell.label.text = "Select Photo"
            default:
                fatalError()
            }
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.get(indexPath.section) {
        case .photoList:
            break
//            navigationController?.pushViewController(BigPhotoViewController(photoPaths[indexPath.row]), animated: true)
        case .actions:
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self

            switch indexPath.row {
            case 0:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    myPickerController.sourceType = .camera
                    present(myPickerController, animated: true, completion: nil)
                }
            case 1:
                myPickerController.sourceType = .photoLibrary
                present(myPickerController, animated: true, completion: nil)
            default:
                fatalError()
            }
        }
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        switch Section.get(indexPath.section) {
        case .photoList:
            return CGSize(width: widthPerItem, height: widthPerItem)
        case .actions:
            return CGSize(width: widthPerItem, height: 80)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
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

        var compression: CGFloat = 0.8

        guard var data = image.jpegData(compressionQuality: compression) else {
            return
        }

        while data.count > PhotoViewController.maxFileSizeInBytes {
            compression *= 0.75
            guard let smallerData = image.jpegData(compressionQuality: compression) else {
                return
            }

            data = smallerData // There should maybe be a better way of checking this but oh well
        }

        print("Compression quality chosen: \(compression)")

        let fileKey = "\(Date().timeIntervalSince1970)".components(separatedBy: ".")[0]
        let filePath = "\(Auth.auth().currentUser!.uid)/\(fileKey)"

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        let uploadTask = imagesRef.child(filePath).putData(data, metadata: metadata)

        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            let percentString = percentComplete.format(pattern: "%.2f")
            self.navigationItem.title = "\(percentString)% uploaded"
        }

        uploadTask.observe(.success) { snapshot in
            self.navigationItem.title = "File upload completed"

            let photoValue = GlobalReviewCoordinator.getCurrentReview()?.extras["photo"]
            var outputPhotoValue: [String: String] = [:]

            if let imagePath = photoValue as? String {
                let pathKey = imagePath.components(separatedBy: ".")[0]
                outputPhotoValue = [pathKey: imagePath]
            } else if let imagePathDict = photoValue as? [String: String] {
                outputPhotoValue = imagePathDict
            }

            outputPhotoValue[fileKey] = snapshot.metadata?.path
            GlobalReviewCoordinator.getCurrentReview()?.extras["photo"] = outputPhotoValue
            self.getNewDataAndReload()
        }

        uploadTask.observe(.failure) { snapshot in
            print("Failure")
            if let error = snapshot.error as NSError? {
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

class THPhotoViewCell: UICollectionViewCell {
    let imageView: UIImageView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let storage = Storage.storage()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.anchorToSuperviewAnchors()
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    var imagePath: String? {
        didSet {
            let storageRef = storage.reference()
            guard let path = imagePath else { return }
            let imageRef = storageRef.child(path)

            imageRef.getData(maxSize: PhotoViewController.maxFileSizeInBytes) { data, error in
                if let error = error {
                    print(error)
                    Analytics.logEvent("image_download_error", parameters: nil)
                } else {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
}

class THPhotoActionCell: UICollectionViewCell {
    let label: UILabel = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = Themer.DarkTheme.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Themer.DarkTheme.backgroundHighlighted
        layer.cornerRadius = 8
        contentView.addSubview(label)
        label.anchorToSuperviewAnchors()
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
