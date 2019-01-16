//
//  String+Truncate.swift
//  feedback
//
//  Created by James Little on 1/16/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation

extension String {
    func truncate(length: Int, trailing: String? = "...") -> String {
        if self.count > length {
            return self[..<self.index(self.startIndex, offsetBy: length)] + (trailing ?? "")
        } else {
            return self
        }
    }
}
