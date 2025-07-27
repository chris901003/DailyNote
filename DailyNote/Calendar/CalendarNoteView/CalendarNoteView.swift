// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol CalendarNoteViewDelegate: AnyObject {
    func updateContentHeight(height: CGFloat)
}

class CalendarNoteView: UIView {
    var noteData: [NoteData] = [] {
        didSet {
            emptyLabel.alpha = noteData.isEmpty ? 1 : 0
            tableView.alpha = noteData.isEmpty ? 0 : 1
            tableView.reloadData()
            tableView.layoutIfNeeded()
            delegate?.updateContentHeight(height: max(tableView.contentSize.height, 50))
        }
    }
    weak var delegate: CalendarNoteViewDelegate?

    let emptyLabel = UILabel()
    let tableView = UITableView()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.layoutIfNeeded()
        delegate?.updateContentHeight(height: max(tableView.contentSize.height, 50))
    }

    func config(noteData: [NoteData]) {
        self.noteData = noteData.reversed()
    }

    private func setup() {
        emptyLabel.text = "這天沒有留下任何紀錄🫧"
        emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        emptyLabel.textAlignment = .center
        emptyLabel.alpha = 0

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }

    private func layout() {
        addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(CalendarNoteCell.self, forCellReuseIdentifier: CalendarNoteCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarNoteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarNoteCell.cellId, for: indexPath) as? CalendarNoteCell else {
            return UITableViewCell()
        }
        cell.config(noteData: noteData[indexPath.row])
        return cell
    }
}
