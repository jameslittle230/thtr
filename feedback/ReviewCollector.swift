//
//  ReviewCollector.swift
//  feedback
//
//  Created by James Little on 3/21/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation
import Firebase

final class ReviewCollector {
    static let instance = ReviewCollector()
    static let updateNotification = Notification.Name(rawValue: "ReviewCollectorUpdate")

    var reviews: [String: Review]

    private init() {
        reviews = [:]
    }

    static func startListener(withUserEmail userEmail: String) {
        func snapshotToReview(_ snapshot: Any) -> Review? {
            guard let snapshot = snapshot as? DataSnapshot else { return nil }
            return Review(snapshot: snapshot)
        }

        func reviewsToDict(_ collection: [String: Review], _ review: Review) -> [String: Review] {
            var output = collection
            if let key = review.key {
                output[key] = review
            }
            return output
        }

        let dbRef = Database.database().reference(withPath: "reviews")
        dbRef.queryOrdered(byChild: "updated")
            .queryEqual(toValue: userEmail, childKey: "user")
            .observe(.value) { (multiSnapshot: DataSnapshot) -> Void in
                instance.reviews = multiSnapshot.children.compactMap(snapshotToReview).reduce([:], reviewsToDict)
                print("Reviews updated: \(instance.reviews.count) items")
                NotificationCenter.default.post(Notification(name: ReviewCollector.updateNotification))
        }
    }
}
