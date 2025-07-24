// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CalendarDayCell: UICollectionViewCell {
    static let cellId = "CalendarDayCellId"

    let dayLabel = UILabel()
    let amountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = ""
        amountLabel.text = ""
    }

    func config(day: String, amount: String) {
        dayLabel.text = day
        amountLabel.text = amount
        amountLabel.textColor = amount == "0" ? .secondaryLabel : .black
    }

    private func setup() {
        dayLabel.text = "1"
        dayLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dayLabel.textAlignment = .center
        dayLabel.numberOfLines = 1

        amountLabel.text = "0"
        amountLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor, constant: -8)
        ])

        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
