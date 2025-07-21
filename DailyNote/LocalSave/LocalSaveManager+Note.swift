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

    static func createFrom(data: NoteData) -> LocalSaveNoteData {
        .init(note: data.note, startDate: data.startDate, endDate: data.endDate, numberOfImages: data.images.count)
    }
}

// MARK: - Note
extension LocalSaveManager {
    func createNewNote(note: NoteData) throws {
        let saveNoteData = LocalSaveNoteData.createFrom(data: note)
        let jsonData = try encoder.encode(saveNoteData)
        let basePath = try createNewNoteFolder(startTime: note.startDate)
        let dataPath = basePath.appendingPathComponent("note.json")
        try jsonData.write(to: dataPath)
        for (index, image) in note.images.enumerated() {
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imagePath = basePath.appendingPathComponent("image-\(index + 1).jpg")
            try imageData?.write(to: imagePath)
        }
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
            return NoteData(note: noteData.note, images: imgs, startDate: noteData.startDate, endDate: noteData.endDate)
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
}
