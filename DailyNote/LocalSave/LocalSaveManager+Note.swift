// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct LocalSaveNoteData: Codable {
    let note: String
    let startDate: Date
    let endDate: Date
    let numberOfImages: Int
    var folderName: String

    static func createFrom(data: NoteData) -> LocalSaveNoteData {
        .init(note: data.note, startDate: data.startDate, endDate: data.endDate, numberOfImages: data.images.count, folderName: data.folderName)
    }
}

// MARK: - Note
extension LocalSaveManager {
    func createNewNote(note: NoteData) throws {
        var note = note
        let basePath = try createNewNoteFolder(startTime: note.startDate)
        note.folderName = basePath.lastPathComponent
        try saveNote(note: note, path: basePath)
    }

    func updateNote(oldNote: NoteData, newNote: NoteData) throws {
        let basePath = try deleteNote(noteData: oldNote)
        try fileManager.createDirectory(at: basePath, withIntermediateDirectories: true)
        var note = newNote
        note.folderName = oldNote.folderName
        try saveNote(note: note, path: basePath)
    }

    @discardableResult
    func deleteNote(noteData: NoteData) throws -> URL {
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: noteData.startDate))
        let month = String(format: "%02d", calendar.component(.month, from: noteData.startDate))
        let day = String(format: "%02d", calendar.component(.day, from: noteData.startDate))
        let basePath = notePath
            .appendingPathComponent(year)
            .appendingPathComponent(month)
            .appendingPathComponent(day)
            .appendingPathComponent(noteData.folderName)
        try fileManager.removeItem(at: basePath)
        try deleteRedundantFolders(year: year, month: month, day: day)
        return basePath
    }

    func getFolders(url: URL) throws -> [String] {
        try fileManager.contentsOfDirectory(atPath: url.path).sorted(by: >)
    }

    func loadDayNotes(year: String, month: String, day: String) throws -> [NoteData] {
        let loadPath = notePath
            .appendingPathComponent(year)
            .appendingPathComponent(month)
            .appendingPathComponent(day)
        let notesPath = try getFolders(url: loadPath)
        return try notesPath.map { path in
            loadPath.appendingPathComponent(path)
        }.map { url in
            let noteURL = url.appendingPathComponent("note.json")
            let data = try Data(contentsOf: noteURL)
            let noteData = try JSONDecoder().decode(LocalSaveNoteData.self, from: data)
            var images: [UIImage?] = []
            for idx in 0..<noteData.numberOfImages {
                let imageURL = url.appendingPathComponent("image-\(idx + 1).jpg")
                images.append(UIImage(contentsOfFile: imageURL.path))
            }
            let imgs = images.compactMap { $0 }
            return NoteData(
                note: noteData.note, images: imgs, startDate: noteData.startDate, endDate: noteData.endDate, folderName: noteData.folderName
            )
        }
    }
}

// MARK: - Private Function
private extension LocalSaveManager {
    func createNewNoteFolder(startTime: Date) throws -> URL {
        var index = 1
        let calendar = Calendar.current
        let year = calendar.component(.year, from: startTime)
        let month = String(format: "%02d", calendar.component(.month, from: startTime))
        let day = String(format: "%02d", calendar.component(.day, from: startTime))
        let hour = String(format: "%02d", calendar.component(.hour, from: startTime))
        let minute = String(format: "%02d", calendar.component(.minute, from: startTime))
        let basePath = notePath
            .appendingPathComponent("\(year)")
            .appendingPathComponent("\(month)")
            .appendingPathComponent("\(day)")
        while true {
            let folderPath = basePath.appendingPathComponent("\(hour)\(minute)-\(index)")
            if fileManager.fileExists(atPath: folderPath.path) { continue }
            index += 1
            try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            return folderPath
        }
    }

    func saveNote(note: NoteData, path: URL) throws {
        let saveNoteData = LocalSaveNoteData.createFrom(data: note)
        let jsonData = try encoder.encode(saveNoteData)
        let dataPath = path.appendingPathComponent("note.json")
        try jsonData.write(to: dataPath)
        for (index, image) in note.images.enumerated() {
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imagePath = path.appendingPathComponent("image-\(index + 1).jpg")
            try imageData?.write(to: imagePath)
        }
    }

    func deleteRedundantFolders(year: String, month: String, day: String) throws {
        let dayPath = notePath.appendingPathComponent(year).appendingPathComponent(month).appendingPathComponent(day)
        if try getFolders(url: dayPath).isEmpty {
            try fileManager.removeItem(at: dayPath)
        }
        let monthPath = notePath.appendingPathComponent(year).appendingPathComponent(month)
        if try getFolders(url: monthPath).isEmpty {
            try fileManager.removeItem(at: monthPath)
        }
        let yearPath = notePath.appendingPathComponent(year)
        if try getFolders(url: yearPath).isEmpty {
            try fileManager.removeItem(at: yearPath)
        }
    }
}
