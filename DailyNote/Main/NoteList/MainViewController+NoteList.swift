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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MNLNoteCell.cellId, for: indexPath) as? MNLNoteCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.config(
            data: .init(note: "這是第一篇日記\n第一條內容\n第二條內容\n第三條內容\n第四條內容\n第五條內容\n第六條內容", images: [UIImage(systemName: "house")!], startDate: .now, endDate: .now)
        )
        return cell
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
}
