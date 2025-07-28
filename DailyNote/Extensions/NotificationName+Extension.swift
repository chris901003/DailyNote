// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension Notification.Name {
    static let newNote = Notification.Name("NewNote")
    static let updateNote = Notification.Name("UpdateNote")
}

class DNNotification {
    // MARK: - Add new note
    static func sendNewNote(newNote: NoteData) {
        NotificationCenter.default.post(name: .newNote, object: nil, userInfo: ["note": newNote])
    }
    
    static func decodeNewNote(_ notification: Notification) -> NoteData? {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["note"] as? NoteData else { return nil }
        return transaction
    }

    // MARK: - Update Note
    static func sendUpdateNote(oldNote: NoteData, newNote: NoteData) {
        NotificationCenter.default.post(name: .updateNote, object: nil, userInfo: ["oldNote": oldNote, "newNote": newNote])
    }

    static func decodeUpdateNote(_ notification: Notification) -> (oldNote: NoteData, newNote: NoteData)? {
        guard let userInfo = notification.userInfo,
              let oldNote = userInfo["oldNote"] as? NoteData,
              let newNote = userInfo["newNote"] as? NoteData else {
            return nil
        }
        return (oldNote: oldNote, newNote: newNote)
    }
}
