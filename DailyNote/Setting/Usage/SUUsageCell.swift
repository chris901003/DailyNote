// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class SUUsageCell: UITableViewCell {
    static let cellId = "SUUsageCellId"

    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let loadingView = UIActivityIndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        getTotalSize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        getTotalSize()
    }

    private func setup() {
        titleLabel.text = "總使用量"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black

        bodyLabel.text = "--MB"
        bodyLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.alpha = 0

        loadingView.startAnimating()
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        contentView.addSubview(bodyLabel)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bodyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func getTotalSize() {
        Task {
            let localSaveManager = LocalSaveManager()
            do {
                let totalSize = try localSaveManager.getTotalSpaceUsage()
                await MainActor.run {
                    bodyLabel.text = String(format: "%.2f MB", totalSize)
                    bodyLabel.alpha = 1
                    loadingView.alpha = 0
                    loadingView.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    bodyLabel.text = "無法取得大小"
                    bodyLabel.alpha = 1
                    loadingView.alpha = 0
                    loadingView.stopAnimating()
                }
            }
        }
    }
}
