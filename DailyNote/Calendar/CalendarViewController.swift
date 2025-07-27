// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class CalendarViewController: UIViewController {
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    let leftIcon = UIImageView()
    let yearAndMonthLabel = UILabel()
    let rightIcon = UIImageView()
    let collectionView: UICollectionView = {
        var layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            CollectionViewSections.allCases[sectionIdx].getSectionLayoutConfig
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalendarWeekCell.self, forCellWithReuseIdentifier: CalendarWeekCell.cellId)
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.cellId)
        return collectionView
    }()
    let noteView = CalendarNoteView()
    let editButton = CalendarEditButton()

    let manager = CalendarManager()
    var collectionViewHeightConstraint: NSLayoutConstraint!
    var noteViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        Task.detached { [weak self] in
            guard let self else { return }
            do {
                try await manager.loadInitData()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    collectionView.reloadData()
                    noteView.config(noteData: manager.dayNotes)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }

    private func setup() {
        manager.vc = self
        view.backgroundColor = .white

        leftIcon.image = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLeftAction)))
        leftIcon.isUserInteractionEnabled = true

        rightIcon.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        rightIcon.contentMode = .scaleAspectFit
        rightIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRightAction)))
        rightIcon.isUserInteractionEnabled = true

        yearAndMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: manager.currentDate)
        yearAndMonthLabel.font = .systemFont(ofSize: 20, weight: .bold)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false

        noteView.delegate = self
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let mainContentViewHeightConstraint = mainContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        mainContentViewHeightConstraint.priority = .defaultLow
        mainContentViewHeightConstraint.isActive = true

        mainContentView.addSubview(yearAndMonthLabel)
        yearAndMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearAndMonthLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            yearAndMonthLabel.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor)
        ])

        mainContentView.addSubview(leftIcon)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftIcon.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            leftIcon.trailingAnchor.constraint(equalTo: yearAndMonthLabel.leadingAnchor, constant: -8),
            leftIcon.heightAnchor.constraint(equalToConstant: 25),
            leftIcon.widthAnchor.constraint(equalToConstant: 25)
        ])

        mainContentView.addSubview(rightIcon)
        rightIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightIcon.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            rightIcon.leadingAnchor.constraint(equalTo: yearAndMonthLabel.trailingAnchor, constant: 8),
            rightIcon.heightAnchor.constraint(equalToConstant: 25),
            rightIcon.widthAnchor.constraint(equalToConstant: 25)
        ])

        mainContentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: yearAndMonthLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint.isActive = true

        mainContentView.addSubview(noteView)
        noteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            noteView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            noteView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor)
        ])
        noteViewHeightConstraint = noteView.heightAnchor.constraint(equalToConstant: 100)
        noteViewHeightConstraint.isActive = true

        mainContentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: noteView.bottomAnchor),
            editButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            editButton.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Change Month
extension CalendarViewController {
    @objc private func tapLeftAction() {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: manager.currentDate) else {
            return
        }
        manager.currentDate = lastMonth
        updateMonth()
    }

    @objc private func tapRightAction() {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: manager.currentDate) else {
            return
        }
        manager.currentDate = nextMonth
        updateMonth()
    }

    private func updateMonth() {
        yearAndMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: manager.currentDate)
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            collectionViewHeightConstraint.constant = collectionView.contentSize.height
        }
    }
}

// MARK: - CalendarNoteViewDelegate
extension CalendarViewController: CalendarNoteViewDelegate {
    func updateContentHeight(height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.noteViewHeightConstraint.constant = height
        }
    }
}
