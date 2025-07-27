// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CalendarEditCell: UITableViewCell {
    static let cellId = "CalendarEditCell"

    let noteView = UILabel()
    let dateLabel = UILabel()
    let imageIcon = UIImageView()
    var noteData: NoteData?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(noteData: NoteData) {
        self.noteData = noteData
        let startStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: noteData.startDate)
        let endStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: noteData.endDate)
        noteView.text = noteData.note
        dateLabel.text = "\(startStr) ~ \(endStr)"
        imageIcon.alpha = noteData.images.isEmpty ? 0 : 1
    }

    private func setup() {
        noteView.text = "It was supposed to be a dream vacation. They had planned it over a year in advance so that it would be perfect in every way. It had been what they had been looking forward to through all the turmoil and negativity around them. It had been the light at the end of both their tunnels. Now that the dream vacation was only a week away, the virus had stopped all air travel."
        noteView.font = .systemFont(ofSize: 14, weight: .medium)
        noteView.numberOfLines = 0

        dateLabel.text = "06:00 ~ 07:00"
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 1

        imageIcon.image = UIImage(systemName: "photo")
        imageIcon.contentMode = .scaleAspectFit
    }

    private func layout() {
        contentView.addSubview(noteView)
        noteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            noteView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            noteView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])

        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: noteView.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        contentView.addSubview(imageIcon)
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            imageIcon.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            imageIcon.heightAnchor.constraint(equalToConstant: 20),
            imageIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
