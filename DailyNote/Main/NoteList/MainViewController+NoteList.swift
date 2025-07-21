// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

// MARK: - NoteList
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    internal func registerCell() {
        noteTableView.register(MNLNoteCell.self, forCellReuseIdentifier: MNLNoteCell.cellId)
        noteTableView.register(MNLTimeCell.self, forCellReuseIdentifier: MNLTimeCell.cellId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = manager.notes[indexPath.row]
        switch data.type {
            case .note(let noteData):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MNLNoteCell.cellId, for: indexPath) as? MNLNoteCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.config(
                    data: .init(note: noteData.note, images: noteData.images, startDate: noteData.startDate, endDate: noteData.endDate)
                )
                return cell
            case .time(let date):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MNLTimeCell.cellId, for: indexPath) as? MNLTimeCell else {
                    return UITableViewCell()
                }
                cell.config(date: date)
                return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MNLNoteCell else { return }
        tableView.beginUpdates()
        if let lastExtendIndexPath,
            lastExtendIndexPath != indexPath,
            let lastCell = tableView.cellForRow(at: lastExtendIndexPath) as? MNLNoteCell,
            lastCell.isExtended {
            lastCell.extendOrShrinkCell()
        }
        lastExtendIndexPath = lastExtendIndexPath == indexPath ? nil : indexPath
        cell.extendOrShrinkCell()
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == manager.notes.count - 1, !manager.loadData.isLoading, !manager.loadData.isEnd else { return }
        Task { await manager.loadMoreNote() }
    }
}
