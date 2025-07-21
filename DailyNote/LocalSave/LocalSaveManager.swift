// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum LocalSavePathType: String {
    case note = "Note"
}

class LocalSaveManager {
    let fileManager = FileManager.default
    let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let notePath: URL

    init() {
        notePath = basePath.appendingPathComponent(LocalSavePathType.note.rawValue)
        createRootFolderIfNeeded()
    }

    private func createRootFolderIfNeeded() {
        guard !fileManager.fileExists(atPath: notePath.path) else { return }
        do {
            try fileManager.createDirectory(at: notePath, withIntermediateDirectories: true)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Utility
extension LocalSaveManager {
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

    func getTotalSpaceUsage() throws -> Double {
        var totalSize: UInt64 = 0
        totalSize += try folderSize(at: notePath)
        return Double(totalSize) / 1024.0 / 1024.0
    }
}

// MARK: - Private Utility Function
private extension LocalSaveManager {
    func folderSize(at folderURL: URL) throws -> UInt64 {
        var size: UInt64 = 0
        if let enumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: [.fileSizeKey], options: [], errorHandler: nil) {
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey])
                if resourceValues.isRegularFile ?? false {
                    size += UInt64(resourceValues.fileSize ?? 0)
                }
            }
        }
        return size
    }
}
