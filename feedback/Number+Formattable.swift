//
//  Number+Formattable.swift
//  feedback
//
//  Created by James Little on 4/29/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation

protocol Formattable {
    func format(pattern: String) -> String
}
extension Formattable where Self: CVarArg {
    func format(pattern: String) -> String {
        return String(format: pattern, arguments: [self])
    }
}
extension Int: Formattable { }
extension Double: Formattable { }
extension Float: Formattable { }
