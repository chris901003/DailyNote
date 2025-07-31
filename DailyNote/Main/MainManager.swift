// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

extension MainManager {
    struct LoadData {
        var yearIndex: Int = 0
        var monthIndex: Int = 0
        var dayIndex: Int = 0

        var yearList: [String] = []
        var monthList: [String] = []
        var dayList: [String] = []
        var isEnd = true
        var isLoading = false
    }
}

class MainManager {
    let calendar = Calendar.current
    var notes: [MNoteListData] = []

    let localSaveManager = LocalSaveManager()
    var loadData = LoadData()
    weak var vc: MainViewController?

    init() {
        initLoadNote()
    }
}

// MARK: - Load Note
extension MainManager {
    func initLoadNote() {
        loadData = LoadData()
        var yearPath: URL?
        var monthPath: URL?

        loadData.isEnd = true
        loadData.yearList = (try? localSaveManager.getFolders(url: localSaveManager.notePath)) ?? []
        if let year = loadData.yearList.first {
            yearPath = localSaveManager.notePath.appendingPathComponent(year)
            loadData.monthList = (try? localSaveManager.getFolders(url: yearPath!)) ?? []
        }
        if let month = loadData.monthList.first {
            monthPath = yearPath?.appendingPathComponent(month)
            loadData.dayList = (try? localSaveManager.getFolders(url: monthPath!)) ?? []
            loadData.isEnd = false
        }
        loadData.yearIndex = 0
        loadData.monthIndex = 0
        loadData.dayIndex = 0
        Task {
            await vc?.noteTableView.reloadData()
            await loadMoreNote()
        }
    }

    func loadMoreNote() async {
        guard !loadData.isLoading, !loadData.isEnd else { return }
        loadData.isLoading = true
        let year = loadData.yearList[loadData.yearIndex]
        let month = loadData.monthList[loadData.monthIndex]
        let day = loadData.dayList[loadData.dayIndex]
        do {
            let loadNotes = try localSaveManager.loadDayNotes(year: year, month: month, day: day)
            if let firstNote = loadNotes.first {
                notes.append(.init(type: .time(date: firstNote.startDate.getStartOfDay())))
            }
            loadNotes.forEach { note in
                notes.append(.init(type: .note(data: note)))
            }
            await MainActor.run {
                vc?.noteTableView.reloadData()
            }
            getNextLoadDay()
            loadData.isLoading = false
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加載日記失敗")
        }
    }

    private func getNextLoadDay() {
        if loadData.dayIndex == loadData.dayList.count - 1 {
            if loadData.monthIndex == loadData.monthList.count - 1 {
                if loadData.yearIndex == loadData.yearList.count - 1 {
                    loadData.isEnd = true
                } else {
                    loadData.yearIndex += 1
                    let yearPath = localSaveManager.notePath
                        .appendingPathComponent(loadData.yearList[loadData.yearIndex])
                    loadData.monthList = (try? localSaveManager.getFolders(url: yearPath)) ?? []
                    loadData.monthIndex = 0
                }
            } else {
                loadData.monthIndex += 1
                let monthPath = localSaveManager.notePath
                    .appendingPathComponent(loadData.yearList[loadData.yearIndex])
                    .appendingPathComponent(loadData.monthList[loadData.monthIndex])
                loadData.dayList = (try? localSaveManager.getFolders(url: monthPath)) ?? []
                loadData.dayIndex = 0
            }
        } else {
            loadData.dayIndex += 1
        }
    }
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

    func updateNote(idx: Int, newNote: NoteData) throws {
        let data = notes[idx]
        switch data.type {
            case .note(let oldNote):
                var note = newNote
                note.folderName = oldNote.folderName
                try localSaveManager.updateNote(oldNote: oldNote, newNote: note)
                notes[idx] = .init(type: .note(data: note))
                DNNotification.sendUpdateNote(oldNote: oldNote, newNote:  note)
            case .time(_):
                break
        }
    }

    func deleteNote(idx: Int) throws {
        let data = notes.remove(at: idx)
        switch data.type {
            case .note(let note):
                try localSaveManager.deleteNote(noteData: note)
            case .time(_):
                break
        }
    }
}
