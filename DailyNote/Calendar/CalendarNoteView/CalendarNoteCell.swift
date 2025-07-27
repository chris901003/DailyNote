// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CalendarNoteCell: UITableViewCell {
    static let cellId = "CalendarNoteCellId"

    let mainContentView = UIView()
    let dateLabel = UILabel()
    let noteLabel = UILabel()
    let photoView = UIImageView()

    var noteData: NoteData?
    var noteLabelTrailingConstraint: NSLayoutConstraint!
    var noteBottomConstraint: NSLayoutConstraint!
    var photoBottomConstraint: NSLayoutConstraint!
    weak var delegate: PresentableVC?

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
        let startDateStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: noteData.startDate)
        let endDateStr = DateFormatterManager.shared.dateFormat(type: .HH_mm, date: noteData.endDate)
        dateLabel.text = "\(startDateStr) ~ \(endDateStr)"
        noteLabel.text = noteData.note
        photoView.image = noteData.images.first

        if photoView.image != nil {
            photoView.alpha = 1
            photoBottomConstraint.isActive = true
            noteLabelTrailingConstraint.constant = -112
        } else {
            photoView.alpha = 0
            photoBottomConstraint.isActive = false
            noteLabelTrailingConstraint.constant = 0
        }
        layoutIfNeeded()
    }

    private func setup() {
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false

        dateLabel.text = "07:20 ~ 08:45"
        dateLabel.textColor = .secondaryLabel
        dateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dateLabel.textAlignment = .left
        dateLabel.numberOfLines = 1

        noteLabel.text = "It was supposed to be a dream vacation. They had planned it over a year in advance so that it would be perfect in every way. It had been what they had been looking forward to through all the turmoil and negativity around them. It had been the light at the end of both their tunnels. Now that the dream vacation was only a week away, the virus had stopped all air travel."
        noteLabel.textColor = .label
        noteLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        noteLabel.numberOfLines = 0

        photoView.image = UIImage(systemName: "house")
        photoView.contentMode = .scaleAspectFill
        photoView.layer.cornerRadius = 10.0
        photoView.clipsToBounds = true
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhotoView)))
        photoView.isUserInteractionEnabled = true
    }

    private func layout() {
        addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        mainContentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor)
        ])

        mainContentView.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            noteLabel.leadingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.leadingAnchor)
        ])
        noteLabelTrailingConstraint = noteLabel.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor)
        noteLabelTrailingConstraint.isActive = true

        mainContentView.addSubview(photoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: noteLabel.topAnchor),
            photoView.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 100),
            photoView.widthAnchor.constraint(equalToConstant: 100)
        ])

        noteBottomConstraint = noteLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.layoutMarginsGuide.bottomAnchor)
        noteBottomConstraint.priority = .defaultLow
        photoBottomConstraint = photoView.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.layoutMarginsGuide.bottomAnchor)
        photoBottomConstraint.priority = .defaultLow
        let minHeightConstraint = mainContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        minHeightConstraint.priority = .required
        NSLayoutConstraint.activate([
            noteBottomConstraint,
            photoBottomConstraint,
            minHeightConstraint
        ])
    }
}

extension CalendarNoteCell {
    @objc func tapPhotoView() {
        guard let images = noteData?.images else { return }
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
}
