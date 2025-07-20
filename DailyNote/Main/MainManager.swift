// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class MainManager {
    let calendar = Calendar.current
    var notes: [MNoteListData] = []
}

// MARK: - Insert New Note
extension MainManager {
    private func getInsertIndex(note: NoteData) -> Int {
        notes.firstIndex { data in
            switch data.type {
                case .note(let noteData):
                    return noteData.startDate.distance(to: note.startDate) > 0
                case .time(let date):
                    guard let endOfDay = date.getEndOfDay() else { return false }
                    return endOfDay.distance(to: note.startDate) > 0
            }
        } ?? notes.count
    }

    private func insertDateIfNeeded(note: NoteData, index: Int) -> Int {
        if index == 0 {
            notes.insert(.init(type: .time(date: note.startDate.getStartOfDay())), at: index)
            return index + 1
        } else {
            let prev = notes[index - 1].type
            switch prev {
                case .note(let noteData):
                    if !note.startDate.isSameDay(target: noteData.startDate) {
                        notes.insert(.init(type: .time(date: note.startDate.getStartOfDay())), at: index)
                        return index + 1
                    }
                case .time(_):
                    break
            }
        }
        return index
    }

    func addNewNote(note: NoteData) {
        let index = insertDateIfNeeded(note: note, index: getInsertIndex(note: note))
        notes.insert(.init(type: .note(data: note)), at: index)
    }
}
