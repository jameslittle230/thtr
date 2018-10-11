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
    let reviewText: String

    init?(snapshot: DataSnapshot) {
        print(snapshot)
        guard let email = snapshot.childSnapshot(forPath: "user").value as? String,
            let text = snapshot.childSnapshot(forPath: "text").value as? String else {
                return nil
        }

        userEmail = email
        reviewText = text
    }
}
