// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct NoteData {
    let note: String
    let images: [UIImage]
    let startDate: Date
    let endDate: Date
    let folderName: String

    init(note: String, images: [UIImage], startDate: Date, endDate: Date, folderName: String = "") {
        self.note = note
        self.images = images
        self.startDate = startDate
        self.endDate = endDate
        self.folderName = folderName
    }
}
