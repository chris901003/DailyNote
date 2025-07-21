// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

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
}

// MARK: - Private Function
private extension LocalSaveManager {
    func createNewNoteFolder(startTime: Date) throws -> URL {
        var index = 1
        let timeStr = DateFormatterManager.shared.dateFormat(type: .yyyyMMddHHmm, date: startTime)
        while true {
            let folderPath = notePath.appendingPathComponent("\(timeStr)-\(index)")
            if fileManager.fileExists(atPath: folderPath.path) { continue }
            index += 1
            try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            return folderPath
        }
    }
}
