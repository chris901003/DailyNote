// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class CENoteManager {
    let localSaveManager = LocalSaveManager()

    func sendNote(oldNoteData: NoteData?, noteData: NoteData) {
        do {
            if let oldNoteData {
                try localSaveManager.updateNote(oldNote: oldNoteData, newNote: noteData)
                DNNotification.sendUpdateNote(oldNote: oldNoteData, newNote: noteData)
            } else {
                try localSaveManager.createNewNote(note: noteData)
                DNNotification.sendNewNote(newNote: noteData)
            }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
        }
    }
}
