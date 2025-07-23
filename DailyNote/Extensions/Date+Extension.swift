// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension Date {
    func getStartOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    func getEndOfDay() -> Date? {
        guard let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: getStartOfDay()) else {
            return nil
        }
        return startOfTomorrow.addingTimeInterval(-1)
    }

    func isSameDay(target: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: target)
    }
}

extension Date {
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: self) {
            return range.count
        }
        return 30
    }

    func weekdayOfFirstDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        guard let firstDayOfMonth = calendar.date(from: components) else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        return weekday - 1
    }
}
