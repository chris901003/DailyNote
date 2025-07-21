// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum DateFormatType: String {
    case yyyy_MM_dd = "yyyy-MM-dd"
    case yyyy_MM_dd_ch = "yyyy年 MM月 dd日"
    case MM_dd_HH_mm = "MM-dd HH:mm"
    case yyyy_MM_ch = "yyyy年 MM月"
    case HH_mm = "HH:mm"
    case yyyyMMddHHmm = "yyyyMMddHHmm"
}

class DateFormatterManager {
    // Singleton
    static let shared = DateFormatterManager()
    private init() { }

    let dateFormatter = DateFormatter()

    func dateFormat(type: DateFormatType, date: Date) -> String {
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}
