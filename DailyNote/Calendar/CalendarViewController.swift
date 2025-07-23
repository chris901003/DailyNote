// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension CalendarViewController {
    enum CollectionViewSections: CaseIterable {
        case titleSection, dateSection

        var getSectionLayoutConfig: NSCollectionLayoutSection {
            get {
                switch self {
                    case .titleSection:
                        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalHeight(1.0))
                        let item = NSCollectionLayoutItem(layoutSize: itemSize)

                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                        let section = NSCollectionLayoutSection(group: group)
                        return section
                    case .dateSection:
                        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalWidth(1.0 / 7.0))
                        let item = NSCollectionLayoutItem(layoutSize: itemSize)

                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0 / 7.0))
                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                        group.interItemSpacing = .fixed(2)

                        let section = NSCollectionLayoutSection(group: group)
                        section.interGroupSpacing = 2
                        return section
                }
            }
        }
    }
}

class CalendarViewController: UIViewController {
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

    let manager = CalendarManager()
    var collectionViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }

    private func setup() {
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
    }

    private func layout() {
        view.addSubview(yearAndMonthLabel)
        yearAndMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearAndMonthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            yearAndMonthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(leftIcon)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftIcon.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            leftIcon.trailingAnchor.constraint(equalTo: yearAndMonthLabel.leadingAnchor, constant: -8),
            leftIcon.heightAnchor.constraint(equalToConstant: 25),
            leftIcon.widthAnchor.constraint(equalToConstant: 25)
        ])

        view.addSubview(rightIcon)
        rightIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightIcon.centerYAnchor.constraint(equalTo: yearAndMonthLabel.centerYAnchor),
            rightIcon.leadingAnchor.constraint(equalTo: yearAndMonthLabel.trailingAnchor, constant: 8),
            rightIcon.heightAnchor.constraint(equalToConstant: 25),
            rightIcon.widthAnchor.constraint(equalToConstant: 25)
        ])

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: yearAndMonthLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint.isActive = true
    }
}

extension CalendarViewController {
    @objc private func tapLeftAction() {
        print("✅ Left Action")
    }

    @objc private func tapRightAction() {
        print("✅ Right Action")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionViewSections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CollectionViewSections.allCases[section]
        switch sectionType {
            case .titleSection:
                return 7
            case .dateSection:
                return manager.getNumberOfDayCells()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = CollectionViewSections.allCases[indexPath.section]
        switch sectionType {
            case .titleSection:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CalendarWeekCell.cellId, for: indexPath
                ) as? CalendarWeekCell else {
                    return UICollectionViewCell()
                }
                cell.config(idx: indexPath.row)
                return cell
            case .dateSection:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CalendarDayCell.cellId, for: indexPath
                ) as? CalendarDayCell else {
                    return UICollectionViewCell()
                }
                return cell
        }
    }
}
