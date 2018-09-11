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

    func write(withCompletionBlock completionBlock: @escaping ((Error?, Bool, DataSnapshot?) -> Void)) {
        let timestamp = String(Int(floor(Date().timeIntervalSince1970 * 1000)))
        var dbRef = Database.database().reference()
        dbRef = dbRef.child("feedback_entries").child(timestamp)

        dbRef.child("show").setValue(show)
        dbRef.child("time").setValue(dimensions[.timeDistortion])
        dbRef.child("space").setValue(dimensions[.spaceDistortion])
        dbRef.child("body").setValue(dimensions[.bodyDistortion])
        dbRef.child("comments").setValue(comments)
    }
}
