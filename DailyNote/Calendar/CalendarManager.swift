// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class CalendarManager {
    var currentDate: Date

    init() {
        currentDate = .now.getFirstDayOfMonth() ?? .now
    }
}

extension CalendarManager {
    func getNumberOfDayCells() -> Int {
        currentDate.numberOfDaysInMonth() + currentDate.weekdayOfFirstDay()
    }

    func getSkipDays() -> Int {
        currentDate.weekdayOfFirstDay()
    }
}
