//
//  ShowCollector.swift
//  feedback
//
//  Created by James Little on 3/21/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation
import Firebase

final class ShowCollector {
    static let instance = ShowCollector()
    static let updateNotification = Notification.Name(rawValue: "ShowCollectorUpdate")

    var shows: [String: Show]

    private init() {
        shows = [:]
    }

    static func startListener() {
        func snapshotToShow(_ snapshot: Any) -> Show? {
            guard let snapshot = snapshot as? DataSnapshot else { return nil }
            return Show(snapshot: snapshot)
        }

        func showsToDict(_ collection: [String: Show], _ show: Show) -> [String: Show] {
            var output = collection
            if let key = show.key {
                output[key] = show
            }
            return output
        }

        let dbRef = Database.database().reference(withPath: "rich_shows")
        dbRef.observe(.value) { (multiSnapshot: DataSnapshot) -> Void in
            instance.shows = multiSnapshot.children.compactMap(snapshotToShow).reduce([:], showsToDict)
            print("Shows updated: \(instance.shows.count) items")
            NotificationCenter.default.post(Notification(name: ShowCollector.updateNotification))
        }
    }
}
