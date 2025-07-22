// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension CalendarViewController {
    enum CollectionViewSectioins: CaseIterable {
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
    let collectionView: UICollectionView = {
        var layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            CollectionViewSectioins.allCases[sectionIdx].getSectionLayoutConfig
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalendarWeekCell.self, forCellWithReuseIdentifier: CalendarWeekCell.cellId)
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.cellId)
        return collectionView
    }()

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

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint.isActive = true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarWeekCell.cellId, for: indexPath) as? CalendarWeekCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
