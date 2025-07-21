// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension SettingViewController {
    enum Sections: String {
        case file = "檔案"
    }

    enum Rows: String {
        // file
        case usage = "空間使用量"
    }
}

class SettingViewController: UIViewController {
    let iconView = SAppIconView()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    let sections: [Sections] = [.file]
    let rows: [[Rows]] = [[.usage]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.clipsToBounds = true
    }

    private func layout() {
        view.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(XOLeadingTrailingLabelWithIconCell.self, forCellReuseIdentifier: XOLeadingTrailingLabelWithIconCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = rows[indexPath.section][indexPath.row]
        switch type {
            case .usage:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: XOLeadingTrailingLabelWithIconCell.cellId, for: indexPath
                ) as? XOLeadingTrailingLabelWithIconCell else {
                    return UITableViewCell()
                }
                cell.config(title: type.rawValue, info: "")
                return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = rows[indexPath.section][indexPath.row]
        switch type {
            case .usage:
                let usageViewController = SettingUsageViewController()
                navigationController?.pushViewController(usageViewController, animated: true)
        }
    }
}
