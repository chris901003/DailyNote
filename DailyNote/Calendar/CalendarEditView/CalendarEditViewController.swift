// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class CalendarEditViewController: UIViewController {
    let topBar = UIView()
    let tableView = UITableView()
    let addButton = UIImageView()

    let manager: CalendarEditManager
    var isCreate = false
    var updateIdx: Int? = nil

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
            try? await manager.loadNotes()
            await MainActor.run { [weak self] in self?.tableView.reloadData() }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveUpdateNoteNotification),
            name: .updateNote,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveNewNoteNotification),
            name: .newNote,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveDeleteNoteNotification),
            name: .deleteNote,
            object: nil
        )
    }

    private func setup() {
        view.backgroundColor = .white

        topBar.backgroundColor = .systemGray5
        topBar.layer.cornerRadius = 4

        tableView.delegate = self
        tableView.dataSource = self

        addButton.image = UIImage(systemName: "plus.circle")
        addButton.contentMode = .scaleAspectFit
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddAction)))
        addButton.isUserInteractionEnabled = true
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

        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8)
        ])
    }

    private func registerCell() {
        tableView.register(CalendarEditCell.self, forCellReuseIdentifier: CalendarEditCell.cellId)
    }

    @objc private func tapAddAction() {
        var components = DateComponents()
        components.year = Int(manager.year)
        components.month = Int(manager.month)
        components.day = Int(manager.day)
        components.hour = Calendar.current.component(.hour, from: .now)
        components.minute = Calendar.current.component(.minute, from: .now)
        let date = Calendar.current.date(from: components) ?? .now
        let noteData = NoteData(note: "", images: [], startDate: date.previousHourWithSameDay(), endDate: date)
        let noteEditViewController = NoteEditViewController(note: noteData, isCreateMode: true)
        noteEditViewController.delegate = self
        present(noteEditViewController, animated: true)
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

        isCreate = true
        updateIdx = indexPath.row
        let noteEditViewController = NoteEditViewController(note: manager.notes[indexPath.row])
        noteEditViewController.delegate = self
        present(noteEditViewController, animated: true)
    }
}

// MARK: - NoteEditViewControllerDelegate
extension CalendarEditViewController: NoteEditViewControllerDelegate {
    func saveNote(note: NoteData, isCreate: Bool) {
        if isCreate {
            createNote(note: note)
        } else {
            updateNote(note: note)
        }
    }

    private func createNote(note: NoteData) {
        do {
            try manager.createNewNote(note: note)
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
        }
    }

    private func updateNote(note: NoteData) {
        guard let updateIdx else { return }
        do {
            try manager.updateNote(oldNote: manager.notes[updateIdx], newNote: note)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                tableView.reloadData()
                DNNotification.sendUpdateNote(oldNote: manager.notes[updateIdx], newNote: note)
            }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
        }
    }
}

// MARK: - Notification Center
extension CalendarEditViewController {
    @objc private func receiveUpdateNoteNotification(_ notification: Notification) {
        guard let data = DNNotification.decodeUpdateNote(notification) else { return }
        do {
            try manager.updateNote(oldNote: data.oldNote, newNote: data.newNote)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
        }
    }

    @objc private func receiveNewNoteNotification(_ notification: Notification) {
        guard let data = DNNotification.decodeNewNote(notification) else { return }
        manager.newNote(note: data)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc private func receiveDeleteNoteNotification(_ notification: Notification) {
        guard let data = DNNotification.decodeDeleteNote(notification) else { return }
        manager.deleteNote(note: data)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
