// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MNLNoteCellDelegate: PresentableVC {
    func deleteNote(cell: MNLNoteCell)
}

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
    let editButton = UILabel()
    let deleteButton = UIImageView()

    var labelTrailingConstraint: NSLayoutConstraint!
    var data: CellData?
    var isExtended = false
    weak var delegate: MNLNoteCellDelegate?

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

        isExtended = false
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        mainContentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        editButton.alpha = 0
        deleteButton.alpha = 0
    }

    func config(data: CellData) {
        self.data = data
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
            photoView.alpha = 1
            labelTrailingConstraint = label.trailingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: -16)
        } else {
            photoView.alpha = 0
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

        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 10.0
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhotoList)))
        photoView.isUserInteractionEnabled = true

        photoLabel.text = ""
        photoLabel.textColor = .quaternaryLabel
        photoLabel.font = .systemFont(ofSize: 12, weight: .semibold)

        dateLabel.text = "開始時間 ~ 結束時間"
        dateLabel.textColor = .tertiaryLabel
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textAlignment = .left
        dateLabel.numberOfLines = 1

        editButton.text = "編輯"
        editButton.font = .systemFont(ofSize: 14, weight: .semibold)
        editButton.textColor = .systemBlue
        editButton.textAlignment = .center
        editButton.layer.cornerRadius = 15.0
        editButton.layer.borderWidth = 1.5
        editButton.layer.borderColor = UIColor.systemBlue.cgColor
        editButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEditAction)))
        editButton.isUserInteractionEnabled = true
        editButton.alpha = 0

        deleteButton.image = UIImage(systemName: "trash.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
        deleteButton.isUserInteractionEnabled = true
        deleteButton.alpha = 0
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
            dateLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -8)
        ])

        mainContentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        mainContentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension MNLNoteCell {
    func extendOrShrinkCell() {
        isExtended = !isExtended
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            editButton.alpha = isExtended ? 1 : 0
            deleteButton.alpha = isExtended ? 1 :0
            if isExtended {
                label.numberOfLines = 0
                label.textColor = .black
                mainContentView.layer.borderColor = UIColor.black.cgColor
            } else {
                label.numberOfLines = 3
                label.textColor = .secondaryLabel
                mainContentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
            }
        }
    }

    @objc private func showPhotoList() {
        guard let images = data?.images else { return }
        let photoListVC = MNLPhotoListViewController(images: images)
        if let sheet = photoListVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    UIScreen.main.bounds.height / 2
                })
            ]
        }
        delegate?.presentVC(photoListVC)
    }

    @objc private func tapEditAction() {
        print("✅ Edit action")
    }

    @objc private func tapDeleteAction() {
        let alert = UIAlertController(title: "刪除日記", message: "刪除日記後將無法復原", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] _ in
            guard let self else { return }
            delegate?.deleteNote(cell: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        delegate?.presentVC(alert)
    }
}
