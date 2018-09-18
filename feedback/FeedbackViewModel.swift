//
//  FeedbackItemViewModel.swift
//  feedback
//
//  Created by James Little on 9/4/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias FeedbackValue = Float

enum FeedbackDimension {
    case timeDistortion
    case spaceDistortion
    case bodyDistortion
}

class FeedbackViewModel {
    var dimensions: [FeedbackDimension: Float] = [
        .timeDistortion: 0.0,
        .spaceDistortion: 0.0,
        .bodyDistortion: 0.0
    ]

    var comments = ""
    var show = ""

    func write(withCompletionBlock completionBlock: @escaping (() -> Void)) {
        guard let user = Auth.auth().currentUser else {
            let alert = UIAlertController(title: "Error", message: "Gotta be logged in!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "sorry", style: .default, handler: nil))
            (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.topViewController?.present(alert, animated: true, completion: nil)
            return
        }

        let timestamp = String(Int(floor(Date().timeIntervalSince1970 * 1000)))
        var dbRef = Database.database().reference()
        dbRef = dbRef.child("feedback_entries").child(timestamp)

        dbRef.child("show").setValue(show)
        dbRef.child("time").setValue(dimensions[.timeDistortion])
        dbRef.child("space").setValue(dimensions[.spaceDistortion])
        dbRef.child("body").setValue(dimensions[.bodyDistortion])
        dbRef.child("comments").setValue(comments)
        dbRef.child("user_id").setValue(user.uid)

        completionBlock()
    }
}
