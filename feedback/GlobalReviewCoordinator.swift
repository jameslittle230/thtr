//
//  GlobalReviewController.swift
//  feedback
//
//  Created by James Little on 3/8/19.
//  Copyright © 2019 James Little. All rights reserved.
//

import Foundation

class GlobalReviewCoordinator {
    private static var review: Review?

    static func createNew() {
        GlobalReviewCoordinator.review = Review()
    }

    static func setReview(_ review: Review) {
        GlobalReviewCoordinator.review = review
    }

    static func getCurrentReview() -> Review? {
        return GlobalReviewCoordinator.review
    }

    static func unsetCurrentReview() {
        GlobalReviewCoordinator.review = nil
    }
}
