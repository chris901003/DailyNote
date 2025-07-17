// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct MainInputData {
    var note: String
    var startDate: Date
    var endDate: Date

    init(note: String = "", startDate: Date = Date.now, endDate: Date = Date.now) {
        self.note = note
        self.startDate = startDate
        self.endDate = endDate
    }
}

class MInputManager {
    var inputData = MainInputData() {
        didSet {
            let color: UIColor = inputData.note.isEmpty ? .secondaryLabel : .systemBlue
            view?.sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
    }

    weak var view: MInputView?

    func setClockDate() {
        view?.clockView.setStartAndEndTime(startDate: inputData.startDate, endDate: inputData.endDate)
    }
}
