// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class CalendarManager {
    let calendar = Calendar.current
    let localSaveManager = LocalSaveManager()

    var currentDate: Date
    var selectedDate: Date
    var numberOfNotes: [Int: Int]

    init() {
        currentDate = .now.getFirstDayOfMonth() ?? .now
        selectedDate = .now.getStartOfDay()
        numberOfNotes = [:]
    }

    func loadInitData() async throws {
        try await loadMonthData()
    }
}

extension CalendarManager {
    func getNumberOfDayCells() -> Int {
        currentDate.numberOfDaysInMonth() + currentDate.weekdayOfFirstDay()
    }

    func getSkipDays() -> Int {
        currentDate.weekdayOfFirstDay()
    }

    func isSelected(day: Int) -> Bool {
        calendar.isDate(currentDate, equalTo: selectedDate, toGranularity: .month)
        && calendar.component(.day, from: selectedDate) == day
    }
}

// MARK: - Load Month Data
extension CalendarManager {
    func loadMonthData() async throws {
        numberOfNotes = [:]
        let year = calendar.component(.year, from: currentDate)
        let month = String(format: "%02d", calendar.component(.month, from: currentDate))
        let monthPath = localSaveManager.notePath.appendingPathComponent("\(year)").appendingPathComponent("\(month)")
        let days = try localSaveManager.getFolders(url: monthPath)
        days.forEach { day in
            let dayPath = monthPath.appendingPathComponent(day)
            if let notes = try? localSaveManager.getFolders(url: dayPath),
               let dayInt = Int(day) {
                numberOfNotes[dayInt] = notes.count
            }
        }
    }
}
