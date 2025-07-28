// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class CalendarManager {
    let calendar = Calendar.current
    let localSaveManager = LocalSaveManager()

    var currentDate: Date {
        didSet {
            Task {
                do {
                    try await loadMonthData()
                    await MainActor.run { vc?.collectionView.reloadData() }
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .info, information: "本月沒有任何日記")
                }
            }
        }
    }
    var selectedDate: Date {
        didSet {
            Task {
                await loadDayNote()
                await MainActor.run { vc?.noteView.config(noteData: dayNotes) }
            }
        }
    }
    var numberOfNotes: [Int: Int]
    var dayNotes: [NoteData]

    weak var vc: CalendarViewController?

    init() {
        currentDate = .now.getFirstDayOfMonth() ?? .now
        selectedDate = .now.getStartOfDay()
        numberOfNotes = [:]
        dayNotes = []
    }

    func loadInitData() async throws {
        try await loadMonthData()
        await loadDayNote()
    }

    func updateNote(oldNote: NoteData, newNote: NoteData) {
        guard let idx = dayNotes.firstIndex(of: oldNote) else { return }
        dayNotes[idx] = newNote
    }

    func newNote(newNote: NoteData) {
        if newNote.startDate.isSameMonth(target: currentDate) {
            let day = Int(Calendar.current.component(.day, from: newNote.startDate))
            numberOfNotes[day, default: 0] += 1
        }
        guard newNote.startDate.isSameDay(target: selectedDate) else { return }
        dayNotes.append(newNote)
    }

    func deleteNote(note: NoteData) {
        if note.startDate.isSameMonth(target: currentDate) {
            let day = Int(Calendar.current.component(.day, from: note.startDate))
            numberOfNotes[day, default: 1] -= 1
        }
        guard let idx = dayNotes.firstIndex(of: note) else { return }
        dayNotes.remove(at: idx)
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

// MARK: - Load Day Note
extension CalendarManager {
    func loadDayNote() async {
        let year = String(calendar.component(.year, from: selectedDate))
        let month = String(format: "%02d", calendar.component(.month, from: selectedDate))
        let day = String(format: "%02d", calendar.component(.day, from: selectedDate))
        do {
            dayNotes = try localSaveManager.loadDayNotes(year: year, month: month, day: day)
        } catch {
            dayNotes = []
        }
    }
}
