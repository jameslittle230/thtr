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

class Review {
    var key: String?

    let userEmail: String
    var reviewText: String
    var show: String
    var updated: Date

    var extras: [String: Any] = [:]

    var loadedDict: [String: Any]?

    var dict: [String: Any] {
        var output: [String: Any] = [
            "user": userEmail,
            "text": reviewText,
            "show": show,
            "updated": updated.timeIntervalSince1970
        ]

        // Keep old keys if there's a merge conflict
        output.merge(extras) { (current, _) in current }

        return output
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

        self.loadedDict = snapshot.value as? [String: Any]
        self.extras = self.loadedDict?.filter { key, _ in
            if ["user", "text", "show", "updated"].contains(key) {
                return false
            }

            return true
        } ?? [:]
    }

    init?(withShow show: String) {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }

        key = nil
        reviewText = ""
        userEmail = email
        self.show = show
        updated = Date()
    }

    func save() {
        updated = Date()
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
