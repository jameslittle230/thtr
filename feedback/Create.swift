//
//  Create.swift
//  feedback
//
//  Created by James Little on 9/17/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import Foundation

func create<T>(_ setup: ((T) -> Void)) -> T where T: NSObject {
    let obj = T()
    setup(obj)
    return obj
}
