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

    static func newInput() -> MainInputData {
        let endDate = Date.now

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endDate)
        let startDate = hour == 0 ? calendar.startOfDay(for: endDate) : calendar.date(byAdding: .hour, value: -1, to: endDate)
        return .init(startDate: startDate ?? Date.now, endDate: endDate)
    }
}

extension MInputManager {
    enum CustomError: LocalizedError {
        case noteEmpty
        case durationNotFound

        var errorDescription: String? {
            switch self {
                case .noteEmpty:
                    return "內容不能為空"
                case .durationNotFound:
                    return "無法取得時間區間"
            }
        }
    }
}

class MInputManager {
    var inputData = MainInputData.newInput() {
        didSet {
            let color: UIColor = inputData.note.isEmpty ? .secondaryLabel : .systemBlue
            view?.sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
    }

    weak var view: MInputView?

    func setClockDate() {
        view?.clockView.setStartAndEndTime(startDate: inputData.startDate, endDate: inputData.endDate)
    }

    func sendAction() throws {
        guard !inputData.note.isEmpty else { throw CustomError.noteEmpty }
        guard let duration = view?.clockView.getStartAndEndTime() else { throw CustomError.durationNotFound }

        inputData.startDate = duration.startTime
        inputData.endDate = duration.endTime
    }
}
