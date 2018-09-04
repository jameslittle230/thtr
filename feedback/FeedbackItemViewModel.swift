//
//  FeedbackItemViewModel.swift
//  feedback
//
//  Created by James Little on 9/4/18.
//  Copyright © 2018 James Little. All rights reserved.
//

import Foundation

typealias FeedbackValue = Float

enum FeedbackDimension {
    case timeDistortion
    case spaceDistortion
    case bodyDistortion
}

class FeedbackItemViewModel {
    var type: FeedbackDimension
    var value: FeedbackValue

    init(type: FeedbackDimension, value: FeedbackValue) {
        self.type = type
        self.value = value
    }
}
