// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MIClockView: UIView {
    let iconView = UIImageView()
    let startDatePicker = UIDatePicker()
    let label = UILabel()
    let endDatePicker = UIDatePicker()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setNextTimeRange() {
        let calendar = Calendar.current
        if let nextHour = calendar.date(byAdding: .hour, value: 1, to: endDatePicker.date),
           let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: endDatePicker.date) {
            startDatePicker.date = endDatePicker.date
            endDatePicker.date = min(nextHour, endOfDay)
        }
    }

    private func setup() {
        iconView.image = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        startDatePicker.datePickerMode = .time
        startDatePicker.preferredDatePickerStyle = .compact
        startDatePicker.addTarget(self, action: #selector(setValidDate), for: .valueChanged)

        label.text = "~"
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        endDatePicker.datePickerMode = .time
        endDatePicker.preferredDatePickerStyle = .compact
        endDatePicker.addTarget(self, action: #selector(setValidDate), for: .valueChanged)
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 25),
            iconView.heightAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDatePicker.topAnchor.constraint(equalTo: topAnchor),
            startDatePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            startDatePicker.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
        ])

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 4)
        ])

        addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDatePicker.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            endDatePicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            endDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc private func setMinimumDateAndMaximumDate() {
        startDatePicker.maximumDate = endDatePicker.date
        endDatePicker.minimumDate = startDatePicker.date
    }

    @objc private func setValidDate() {
        if startDatePicker.date > endDatePicker.date {
            endDatePicker.date = startDatePicker.date
        }
        if endDatePicker.date < startDatePicker.date {
            startDatePicker.date = endDatePicker.date
        }
    }
}

extension MIClockView {
    func setStartAndEndTime(startDate: Date, endDate: Date) {
        startDatePicker.date = startDate
        endDatePicker.date = endDate
    }

    func getStartAndEndTime() -> (startTime: Date, endTime: Date) {
        return (startDatePicker.date, endDatePicker.date)
    }
}
