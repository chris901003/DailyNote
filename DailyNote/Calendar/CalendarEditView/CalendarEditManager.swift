// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class CalendarEditManager {
    let localSaveManager = LocalSaveManager()

    let year: String
    let month: String
    let day: String
    var notes: [NoteData] = []

    init(year: String, month: String, day: String) {
        self.year = year
        self.month = month
        self.day = day
    }

    func loadNotes() async throws {
        notes = try localSaveManager.loadDayNotes(year: year, month: month, day: day)
    }

    func createNewNote(note: NoteData) throws {
        let newData = note.getStartDate()
        guard newData.year == year, newData.month == month, newData.day == day else { return }
        let newNote = try localSaveManager.createNewNote(note: note)
        DNNotification.sendNewNote(newNote: newNote)
    }

    func updateNote(oldNote: NoteData, newNote: NoteData) throws {
        guard let idx = notes.firstIndex(where: { $0 == oldNote }) else { return }
        try localSaveManager.updateNote(oldNote: oldNote, newNote: newNote)
        notes[idx] = newNote
    }

    func newNote(note: NoteData) {
        let newData = note.getStartDate()
        guard newData.year == year, newData.month == month, newData.day == day else { return }
        notes.append(note)
    }

    func deleteNote(note: NoteData) {
        guard let idx = notes.firstIndex(of: note) else { return }
        notes.remove(at: idx)
    }
}
