// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class SAppIconView: UIView {
    let dailyNoteIcon = UIImageView()
    let label = UILabel()
    let copyright = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        dailyNoteIcon.image = UIImage(named: "MainIcon")
        dailyNoteIcon.contentMode = .scaleAspectFit
        dailyNoteIcon.layer.cornerRadius = 10.0
        dailyNoteIcon.clipsToBounds = true

        label.text = "Daily Note"
        label.font = .systemFont(ofSize: 24, weight: .bold)

        copyright.text = "Daily Note © 2025 xxooooxx.org\nAll rights reserved."
        copyright.font = .systemFont(ofSize: 14, weight: .semibold)
        copyright.textColor = .secondaryLabel
        copyright.numberOfLines = 2
    }

    private func layout() {
        addSubview(dailyNoteIcon)
        dailyNoteIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyNoteIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyNoteIcon.topAnchor.constraint(equalTo: topAnchor),
            dailyNoteIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
            dailyNoteIcon.heightAnchor.constraint(equalToConstant: 100),
            dailyNoteIcon.widthAnchor.constraint(equalToConstant: 100)
        ])

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: dailyNoteIcon.trailingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -6)
        ])

        addSubview(copyright)
        copyright.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyright.leadingAnchor.constraint(equalTo: dailyNoteIcon.trailingAnchor, constant: 16),
            copyright.topAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            copyright.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
