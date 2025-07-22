// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CalendarWeekCell: UICollectionViewCell {
    static let cellId = "CalendarWeekCellId"

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        label.text = "日"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
