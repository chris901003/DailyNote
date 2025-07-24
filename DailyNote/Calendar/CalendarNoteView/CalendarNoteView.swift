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
    var noteData: [NoteData] = []
    weak var delegate: CalendarNoteViewDelegate?

    let tableView = UITableView()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.updateContentHeight(height: tableView.contentSize.height)
    }

    func config(noteData: [NoteData]) {
        self.noteData = noteData
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarNoteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Just for test"
        return cell
    }
}
