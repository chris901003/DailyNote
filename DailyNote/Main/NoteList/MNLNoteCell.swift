// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension MNLNoteCell {
    struct CellData {
        let note: String
        let images: [UIImage]
        let startDate: Date
        let endDate: Date
    }
}

class MNLNoteCell: UITableViewCell {
    static let cellId = "MNLNoteCellId"

    let mainContentView = UIView()
    let label = UILabel()
    let dateLabel = UILabel()
    let photoView = UIImageView()
    let photoLabel = UILabel()

    var labelTrailingConstraint: NSLayoutConstraint!
    var data: CellData?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultConfig()
    }

    private func defaultConfig() {
        label.text = "日記"
        dateLabel.text = "開始時間 ~ 結束時間"
        photoView.image = nil
        photoLabel.text = ""
    }

    func config(data: CellData) {
        label.text = data.note
        if !data.images.isEmpty {
            photoView.image = data.images.first
            photoLabel.text = "\(data.images.count)張照片"
        }
        let startDateStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: data.startDate)
        let endDateStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: data.endDate)
        dateLabel.text = "\(startDateStr) ~ \(endDateStr)"

        labelTrailingConstraint.isActive = false
        if photoView.image != nil {
            labelTrailingConstraint = label.trailingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: -16)
        } else {
            labelTrailingConstraint = label.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8)
        }
        labelTrailingConstraint.isActive = true
    }

    private func setup() {
        selectionStyle = .none

        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderWidth = 1.5
        mainContentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor

        label.text = "日記"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3

        photoView.image = UIImage(named: "InitialBackground")
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 10.0

        photoLabel.text = "共 2 張照片"
        photoLabel.textColor = .quaternaryLabel
        photoLabel.font = .systemFont(ofSize: 12, weight: .semibold)

        dateLabel.text = "開始時間 ~ 結束時間"
        dateLabel.textColor = .tertiaryLabel
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textAlignment = .left
        dateLabel.numberOfLines = 1
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        mainContentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16)
        ])
        labelTrailingConstraint = label.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8)
        labelTrailingConstraint.isActive = true

        mainContentView.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 16),
            photoView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            photoView.widthAnchor.constraint(equalToConstant: 60),
            photoView.heightAnchor.constraint(equalToConstant: 60)
        ])

        mainContentView.addSubview(photoLabel)
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 4),
            photoLabel.centerXAnchor.constraint(equalTo: photoView.centerXAnchor)
        ])

        mainContentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 8),
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: photoView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -8)
        ])
    }
}
