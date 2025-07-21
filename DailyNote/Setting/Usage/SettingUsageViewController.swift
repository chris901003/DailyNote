// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension SettingUsageViewController {
    enum Sections: String {
        case usage = "使用量"
    }

    enum Rows: String {
        case used = "已使用"
        case deleteAll = "刪除所有日記"
    }
}

class SettingUsageViewController: UIViewController {
    let sections: [Sections] = [.usage]
    let rows: [[Rows]] = [[.used, .deleteAll]]
    let footerMessage: [String?] = ["本功能可協助您刪除所有應用程式內的資料。請注意，資料一旦刪除後將無法還原，請務必謹慎操作。"]

    let tableView = UITableView(frame: .zero, style: .insetGrouped)

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
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(SUUsageCell.self, forCellReuseIdentifier: SUUsageCell.cellId)
        tableView.register(XOCenterLabelCell.self, forCellReuseIdentifier: XOCenterLabelCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingUsageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        footerMessage[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = rows[indexPath.section][indexPath.row]
        switch type {
            case .used:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SUUsageCell.cellId, for: indexPath
                ) as? SUUsageCell else {
                    return UITableViewCell()
                }
                return cell
            case .deleteAll:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: XOCenterLabelCell.cellId, for: indexPath
                ) as? XOCenterLabelCell else {
                    return UITableViewCell()
                }
                cell.config(label: "刪除", color: .systemRed)
                return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = rows[indexPath.section][indexPath.row]
        switch type {
            case .deleteAll:
                let alertController = UIAlertController(title: "刪除資料", message: "刪除後將無法復原", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] _ in
                    self?.deleteAllFile()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                present(alertController, animated: true)
            default:
                break
        }
    }
}

extension SettingUsageViewController {
    private func deleteAllFile() {
        print("✅ Delete all file")
    }
}
