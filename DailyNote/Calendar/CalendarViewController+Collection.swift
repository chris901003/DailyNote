// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

// MARK: - CollectionViewSections
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
                let day = indexPath.row - manager.getSkipDays() + 1
                if day > 0 {
                    cell.config(day: "\(day)", amount: "\(manager.numberOfNotes[day, default: 0])", isSelected: manager.isSelected(day: day))
                } else {
                    cell.config(day: "", amount: "", isSelected: false)
                }
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section != 0,
              indexPath.row >= manager.getSkipDays() else { return }
        let calendar = Calendar.current
        let lastDay = calendar.component(.day, from: manager.selectedDate)
        let lastSelectedIndex = IndexPath(row: lastDay + manager.getSkipDays() - 1, section: 1)
        if let lastSelectedCell = collectionView.cellForItem(at: lastSelectedIndex) as? CalendarDayCell,
           let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCell {
            lastSelectedCell.deSelected()
            cell.selected()
            updateSelectedDay(selectedDay: indexPath.row - manager.getSkipDays() + 1)
        }
    }

    private func updateSelectedDay(selectedDay: Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: manager.currentDate)
        let month = calendar.component(.month, from: manager.currentDate)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = selectedDay
        manager.selectedDate = calendar.date(from: components) ?? .now
    }
}
