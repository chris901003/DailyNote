// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct MainInputData {
    var note: String
    var startDate: Date
    var endDate: Date
    var photos: [UIImage] = [] // Source from camera
    var images: [UIImage] = [] // Source from photo library

    init(note: String = "", startDate: Date = Date.now, endDate: Date = Date.now) {
        self.note = note
        self.startDate = startDate
        self.endDate = endDate
    }

    static func newInput() -> MainInputData {
        let endDate = Date.now

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endDate)
        let startDate = hour == 0 ? calendar.startOfDay(for: endDate) : calendar.date(byAdding: .hour, value: -1, to: endDate)
        return .init(startDate: startDate ?? Date.now, endDate: endDate)
    }
}
