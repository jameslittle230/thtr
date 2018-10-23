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
    var show: String
    var key: String?
    var updated: Date?

    var dict: [String: Any] {
        return [
            "user": userEmail,
            "text": reviewText,
            "show": show,
            "updated": Date().timeIntervalSince1970
        ]
    }

    init?(snapshot: DataSnapshot) {
        guard let email = snapshot.childSnapshot(forPath: "user").value as? String,
            let text = snapshot.childSnapshot(forPath: "text").value as? String,
            let show = snapshot.childSnapshot(forPath: "show").value as? String,
            let updated = snapshot.childSnapshot(forPath: "updated").value as? Double else {
                return nil
        }

        key = snapshot.key
        userEmail = email
        reviewText = text
        self.show = show
        self.updated = Date(timeIntervalSince1970: TimeInterval(updated))
    }

    init?(withShow show: String) {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }

        key = nil
        reviewText = ""
        userEmail = email
        self.show = show
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
