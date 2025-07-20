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
        cell.config(
            data: .init(note: "這是第一篇日記\n第一條內容\n第二條內容\n第三條內容", images: [UIImage(systemName: "house")!], startDate: .now, endDate: .now)
        )
        return cell
    }
}
