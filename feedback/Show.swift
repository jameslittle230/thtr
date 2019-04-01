//
//  Show.swift
//  feedback
//
//  Created by James Little on 2/18/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class Show {
    var key: String?

    var creatingUser: String
    var updated: Date
    var created: Date

    var title: String
    var creator: String
    var venue: String
    var date: Date

    let dateFormatter = ISO8601DateFormatter()

    var dict: [String: Any] {
        let output: [String: Any] = [
            "title": title,
            "creator": creator,
            "date": dateFormatter.string(from: date),
            "venue": venue,
            "creatingUser": creatingUser,
            "updated": updated.timeIntervalSince1970,
            "created": created.timeIntervalSince1970
            ]

        return output
    }

    init?(fromDictionary dict: [String: Any]) {
        guard let title = dict["title"] as? String,
            let date = dict["date"] as? Date,
            let creator = dict["creator"] as? String,
            let venue = dict["venue"] as? String else {
                return nil
        }

        self.title = title
        self.date = date
        self.creator = creator
        self.venue = venue

        self.creatingUser = Auth.auth().currentUser?.email ?? ""
        self.created = Date()
        self.updated = Date()
    }

    init?(snapshot: DataSnapshot) {
        guard let title = snapshot.childSnapshot(forPath: "title").value as? String,
            let dateString = snapshot.childSnapshot(forPath: "date").value as? String,
            let creator = snapshot.childSnapshot(forPath: "creator").value as? String,
            let venue = snapshot.childSnapshot(forPath: "venue").value as? String else {
                return nil
        }

        key = snapshot.key
        self.title = title
        self.venue = venue
        self.creator = creator

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        self.date = date

        if let creatingUser = snapshot.childSnapshot(forPath: "creatingUser").value as? String {
            self.creatingUser = creatingUser
        } else {
            self.creatingUser = Auth.auth().currentUser?.email ?? ""
        }

        if let updated = snapshot.childSnapshot(forPath: "updated").value as? Double {
            self.updated = Date(timeIntervalSince1970: TimeInterval(updated))
        } else {
            self.updated = Date()
        }

        if let created = snapshot.childSnapshot(forPath: "created").value as? Double {
            self.created = Date(timeIntervalSince1970: TimeInterval(created))
        } else {
            self.created = self.updated
        }

//        self.description = snapshot.childSnapshot(forPath: "description").value as? String

//        if let lat = snapshot.childSnapshot(forPath: "loc").childSnapshot(forPath: "lat").value as? Double,
//            let long = snapshot.childSnapshot(forPath: "loc").childSnapshot(forPath: "long").value as? Double {
//                loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        }
    }

    func save() {
        updated = Date()
        let dbRef = Database.database().reference(withPath: "rich_shows")
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

    func delete() {
        let dbRef = Database.database().reference(withPath: "rich_shows")
        if let key = key {
            let newRef = dbRef.child(key)
            newRef.removeValue()
        }
    }
}
