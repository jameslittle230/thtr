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

    var name: String
    var playwright: String
    var description: String
    var theater: String
    var date: Date?
    var loc: CLLocationCoordinate2D?
    var created: Date?

    let dateFormatter = ISO8601DateFormatter()

    var dict: [String: Any] {
        return [
            "name": name,
            "playwright": playwright,
            "date": date ?? "",
            "loc": [
                "lat": loc?.latitude,
                "long": loc?.longitude
            ],
            "theater": theater,
            "description": description
        ]
    }

    init?(snapshot: DataSnapshot) {
        guard let name = snapshot.childSnapshot(forPath: "name").value as? String,
            let description = snapshot.childSnapshot(forPath: "description").value as? String,
            let dateString = snapshot.childSnapshot(forPath: "date").value as? String,
            let playwright = snapshot.childSnapshot(forPath: "playwright").value as? String,
            let theater = snapshot.childSnapshot(forPath: "theater").value as? String else {
                return nil
        }

        key = snapshot.key
        self.name = name
        self.description = description
        self.theater = theater
        self.playwright = playwright

        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        }

        if let lat = snapshot.childSnapshot(forPath: "loc").childSnapshot(forPath: "lat").value as? Double,
            let long = snapshot.childSnapshot(forPath: "loc").childSnapshot(forPath: "long").value as? Double {
                loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }

    func save() {
        created = Date()
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
