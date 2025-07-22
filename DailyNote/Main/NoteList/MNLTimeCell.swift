// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MNLTimeCell: UITableViewCell {
    static let cellId = "MNLTimeCell"

    let mainContentView = UIView()
    let leftSepLineView = UIView()
    let labelView = UILabel()
    let rightSepLineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(date: Date) {
        labelView.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: date)
    }

    private func setup() {
        leftSepLineView.backgroundColor = .secondarySystemBackground
        leftSepLineView.layer.cornerRadius = 2.5

        labelView.text = "時間分隔線"
        labelView.textColor = .secondaryLabel
        labelView.font = .systemFont(ofSize: 16, weight: .semibold)

        rightSepLineView.backgroundColor = .secondarySystemBackground
        rightSepLineView.layer.cornerRadius = 2.5
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        mainContentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            labelView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            labelView.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor)
        ])

        mainContentView.addSubview(leftSepLineView)
        leftSepLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftSepLineView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            leftSepLineView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            leftSepLineView.trailingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: -8),
            leftSepLineView.heightAnchor.constraint(equalToConstant: 3)
        ])

        mainContentView.addSubview(rightSepLineView)
        rightSepLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightSepLineView.leadingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 8),
            rightSepLineView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            rightSepLineView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            rightSepLineView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
}
