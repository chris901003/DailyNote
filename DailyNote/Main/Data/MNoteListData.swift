// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum MNoteListDataType {
    case note(data: NoteData)
    case time(date: Date)
}

struct MNoteListData {
    let type: MNoteListDataType
}
