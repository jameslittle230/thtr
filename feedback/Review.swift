//
//  Review.swift
//  feedback
//
//  Created by James Little on 10/2/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import Foundation
import Firebase

typealias ReviewID = String

struct Review {
    let userEmail: String
    var reviewText: String
    var key: String?

    var dict: [String: Any] {
        let dict = [
            "user": userEmail,
            "text": reviewText
        ]

        return dict
    }

    init?(snapshot: DataSnapshot) {
        guard let email = snapshot.childSnapshot(forPath: "user").value as? String,
            let text = snapshot.childSnapshot(forPath: "text").value as? String else {
                return nil
        }

        key = snapshot.key
        userEmail = email
        reviewText = text
    }

    init?() {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }

        key = nil
        reviewText = ""
        userEmail = email
    }

    func save() {
        let dbRef = Database.database().reference(withPath: "reviews")
        if let key = key {
            // update record
            let newRef = dbRef.child(key)
            newRef.setValue(self.dict)
        } else {
            // new ref
            let newRef = dbRef.childByAutoId()
            newRef.setValue(self.dict)
        }
    }
}
