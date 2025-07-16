// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct MainInputData {
    var note: String

    init(note: String = "") {
        self.note = note
    }
}

class MInputManager {
    var inputData = MainInputData()
}
