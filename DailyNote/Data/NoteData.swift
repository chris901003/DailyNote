// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct NoteData: Equatable {
    let note: String
    let images: [UIImage]
    let startDate: Date
    let endDate: Date
    var folderName: String

    init(note: String, images: [UIImage], startDate: Date, endDate: Date, folderName: String = "") {
        self.note = note
        self.images = images
        self.startDate = startDate
        self.endDate = endDate
        self.folderName = folderName
    }

    static func == (lhs: NoteData, rhs: NoteData) -> Bool {
        return lhs.note == rhs.note
        && lhs.startDate == rhs.startDate
        && lhs.endDate == rhs.endDate
        && lhs.folderName == rhs.folderName
    }

    func getStartDate() -> (year: String, month: String, day: String) {
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: startDate))
        let month = String(format: "%02d", calendar.component(.month, from: startDate))
        let day = String(format: "%02d", calendar.component(.day, from: startDate))
        return (year, month, day)
    }
}
