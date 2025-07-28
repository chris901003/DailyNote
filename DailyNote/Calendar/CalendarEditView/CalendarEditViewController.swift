// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CalendarEditViewController: UIViewController {
    let topBar = UIView()
    let tableView = UITableView()

    let manager: CalendarEditManager

    init(year: String, month: String, day: String) {
        self.manager = CalendarEditManager(year: year, month: month, day: day)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
        Task.detached { [weak self] in
            guard let self else { return }
            do {
                try await manager.loadNotes()
                await MainActor.run { [weak self] in self?.tableView.reloadData() }
            } catch {
                print("✅ Error: \(error.localizedDescription)")
            }
        }
    }

    private func setup() {
        view.backgroundColor = .white

        topBar.backgroundColor = .systemGray5
        topBar.layer.cornerRadius = 4

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            topBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBar.widthAnchor.constraint(equalToConstant: 40),
            topBar.heightAnchor.constraint(equalToConstant: 6)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(CalendarEditCell.self, forCellReuseIdentifier: CalendarEditCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEditCell.cellId, for: indexPath) as? CalendarEditCell else {
            return UITableViewCell()
        }
        cell.config(noteData: manager.notes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let noteViewController = CENoteViewController(noteData: manager.notes[indexPath.row])
        present(noteViewController, animated: true)
    }
}
